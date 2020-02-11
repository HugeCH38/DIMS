USE master;

IF EXISTS (SELECT *
			FROM sysdatabases
			WHERE name = 'DIMS')
BEGIN
	DROP DATABASE DIMS;
END;

CREATE DATABASE DIMS;

IF NOT EXISTS (SELECT *
				FROM syslogins
				WHERE name = 'dba')
BEGIN
	CREATE LOGIN dba WITH PASSWORD = 'abcd1234@', DEFAULT_DATABASE = DIMS;
END

GO

USE DIMS;

CREATE USER dba FOR LOGIN dba WITH DEFAULT_SCHEMA = dbo;

EXEC sp_addrolemember 'db_owner', 'dba';

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

CREATE TABLE Admin( -- 库存管理员
	Ano VARCHAR(20) PRIMARY KEY, -- 编号
	Aname VARCHAR(20) NOT NULL, -- 姓名
	Asex BIT NOT NULL DEFAULT 1, -- 性别 (1 为男，0 为女)
	Aage SMALLINT CHECK (Aage >= 0) NOT NULL, -- 年龄
	Apwd VARCHAR(20) NOT NULL DEFAULT '00000000' -- 登陆密码
);

CREATE TABLE Doctor( -- 医生
	Dno VARCHAR(20) PRIMARY KEY, -- 编号
	Dname VARCHAR(20) NOT NULL, -- 姓名
	Dsex BIT NOT NULL DEFAULT 1, -- 性别 (1 为男，0 为女)
	Dage SMALLINT CHECK (Dage >= 0) NOT NULL, -- 年龄
	Dpwd VARCHAR(20) NOT NULL DEFAULT '00000000' -- 登陆密码
);

CREATE TABLE Nurse( -- 发药处护士
	Nno VARCHAR(20) PRIMARY KEY, -- 编号
	Nname VARCHAR(20) NOT NULL, -- 姓名
	Nsex BIT NOT NULL DEFAULT 1, -- 性别 (1 为男，0 为女)
	Nage SMALLINT CHECK (Nage >= 0) NOT NULL, -- 年龄
	Npwd VARCHAR(20) NOT NULL DEFAULT '00000000' -- 登陆密码
);

CREATE TABLE Supplier( -- 供应商
	Sno VARCHAR(20) PRIMARY KEY, -- 编号
	Sname VARCHAR(60) NOT NULL, -- 名称
	Saddr VARCHAR(60) NOT NULL, -- 地址
	Sphone VARCHAR(20) NOT NULL -- 电话
);

CREATE TABLE Drug( -- 药品
	PDno VARCHAR(20) PRIMARY KEY, -- 编号
	PDname VARCHAR(20) NOT NULL, -- 名称
	PDlife SMALLINT CHECK (PDlife >= 0) NOT NULL -- 保质期 (天数)
);

CREATE TABLE InventoryDrug( -- 库存药品
	PDno VARCHAR(20), -- 编号
	PDbatch DATE, -- 批次
	PDnum SMALLINT CHECK (PDnum >= 0) NOT NULL, -- 数量
	Sno VARCHAR(20) NOT NULL, -- 供应商编号
	SAno VARCHAR(20) NOT NULL, -- 入库库存管理员编号
	Stime DATETIME NOT NULL DEFAULT GETDATE(), -- 入库时间
	PRIMARY KEY(PDno, PDbatch),
	FOREIGN KEY (PDno) REFERENCES Drug(PDno),
	FOREIGN KEY (Sno) REFERENCES Supplier(Sno),
	FOREIGN KEY (SAno) REFERENCES Admin(Ano),
	CHECK (DATEDIFF(DAY, PDbatch, Stime) >= 0)
);

CREATE TABLE DestroyedDrug( -- 已销毁药品
	PDno VARCHAR(20), -- 编号
	PDbatch DATE, -- 批次
	PDnum SMALLINT CHECK (PDnum >= 0) NOT NULL, -- 数量
	Sno VARCHAR(20) NOT NULL, -- 供应商编号
	SAno VARCHAR(20) NOT NULL, -- 入库库存管理员编号
	Stime DATETIME NOT NULL, -- 入库时间
	DAno VARCHAR(20) NOT NULL, -- 销毁库存管理员编号
	Dtime DATETIME NOT NULL DEFAULT GETDATE(), -- 销毁时间
	PRIMARY KEY(PDno, PDbatch),
	FOREIGN KEY (PDno) REFERENCES Drug(PDno),
	FOREIGN KEY (Sno) REFERENCES Supplier(Sno),
	FOREIGN KEY (SAno) REFERENCES Admin(Ano),
	FOREIGN KEy (DAno) REFERENCES Admin(Ano),
	CHECK (DATEDIFF(DAY, PDbatch, Stime) >= 0 AND DATEDIFF(DAY, Stime, Dtime) >= 0)
);

CREATE TABLE Prescription( -- 处方
	Pno INT PRIMARY KEY IDENTITY (1, 1), -- 编号
	Pid VARCHAR(20) NOT NULL, -- 病人身份证号码
	Dno VARCHAR(20) NOT NULL, -- 开出医生编号
	Ptime DATETIME NOT NULL, -- 开出时间
	Nno VARCHAR(20), -- 处理护士编号
	Htime DATETIME, -- 处理时间
	Pstate BIT NOT NULL DEFAULT 0, -- 状态 (1 为已处理，0 为未处理)
	FOREIGN KEY (Dno) REFERENCES Doctor(Dno),
	FOREIGN KEY (Nno) REFERENCES Nurse(Nno),
	CHECK (DATEDIFF(DAY, Ptime, Htime) >= 0)
);

CREATE TABLE PID( -- 处方包含的药品
	Pno INT, -- 处方编号
	PDno VARCHAR(20), -- 药品编号
	PDnum SMALLINT CHECK (PDnum >= 0) NOT NULL, -- 药品数量
	PRIMARY KEY (Pno, PDno),
	FOREIGN KEY (Pno) REFERENCES Prescription(Pno) ON DELETE CASCADE,
	FOREIGN KEY (PDno) REFERENCES Drug(PDno)
);

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

GO

CREATE VIEW DrugView
AS
SELECT d.PDno, d.PDname, d.PDlife, COALESCE(SUM(i.PDnum), 0) AS PDnum
FROM Drug d LEFT OUTER JOIN InventoryDrug i ON d.PDno = i.PDno
GROUP BY d.PDno, d.PDname, d.PDlife;

GO

CREATE VIEW InventoryDrugView
AS
SELECT d.PDno, d.PDname, d.PDlife, i.PDbatch, i.PDnum, i.Sno, i.SAno, i.Stime,
		(d.PDlife - DATEDIFF(DAY, i.PDbatch, GETDATE())) AS Rdays
FROM Drug d, InventoryDrug i
WHERE d.PDno = i.PDno;

GO

CREATE VIEW DestroyedDrugView
AS
SELECT d.PDno, d.PDname, d.PDlife, dd.PDbatch, dd.PDnum, dd.Sno, dd.SAno, dd.Stime, dd.DAno, dd.Dtime
FROM Drug d, DestroyedDrug dd
WHERE d.PDno = dd.PDno;

GO

CREATE VIEW AllPDbatchView
AS
SELECT PDno, PDname, PDlife, PDbatch, PDnum, Sno, SAno, Stime, null AS DAno, null AS Dtime, Rdays
FROM InventoryDrugView
UNION
SELECT PDno, PDname, PDlife, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime, null AS Rdays
FROM DestroyedDrugView;

GO

CREATE VIEW DrugDoctorView
AS
SELECT d.PDno, d.PDname, d.PDlife, (d.PDnum - (SELECT COALESCE(SUM(PID.PDnum), 0)
												FROM Prescription p, PID
												WHERE p.Pno = PID.Pno AND p.Pstate = 0
														AND PID.PDno = d.PDno)) AS PDnum
FROM DrugView d;

GO

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

GO

CREATE PROCEDURE DestroyInventoryDrug @PDno VARCHAR(20), @PDbatch DATE,
										@DAno VARCHAR(20), @Dtime DATETIME, @returnValue SMALLINT OUTPUT
AS
SET XACT_ABORT ON
BEGIN TRAN
DECLARE @PDnum SMALLINT;
DECLARE @Sno VARCHAR(20);
DECLARE @SAno VARCHAR(20);
DECLARE @Stime DATETIME;
SET @returnValue = 0;
SELECT @PDnum = PDnum, @Sno = Sno, @SAno = SAno, @Stime = Stime
FROM InventoryDrug
WHERE PDno = @PDno AND PDbatch = @PDbatch;
SET @returnValue = @returnValue + @@error;
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES(@PDno, @PDbatch, @PDnum, @Sno, @SAno, @Stime, @DAno, @Dtime);
SET @returnValue = @returnValue + @@error;
DELETE FROM InventoryDrug
WHERE PDno = @PDno AND PDbatch = @PDbatch;
SET @returnValue = @returnValue + @@error;
COMMIT TRAN

GO

CREATE PROCEDURE HandleRx @Pno INT, @Nno VARCHAR(20), @Htime DATETIME, @returnValue SMALLINT OUTPUT
AS
SET XACT_ABORT ON
BEGIN TRAN
DECLARE @RxDrugPDno VARCHAR(20);
DECLARE @RxDrugPDnum SMALLINT;
DECLARE @BatchPDbatch DATE;
DECLARE @BatchPDnum SMALLINT;
SET @returnValue = 0;
DECLARE RxDrugs CURSOR FOR SELECT PDno, PDnum
							FROM PID
							WHERE Pno = @Pno;
OPEN RxDrugs;
FETCH NEXT FROM RxDrugs INTO @RxDrugPDno, @RxDrugPDnum;
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE Batches CURSOR FOR SELECT PDbatch, PDnum
								FROM InventoryDrug
								WHERE PDno = @RxDrugPDno
								ORDER BY PDbatch ASC;
	OPEN Batches;
	FETCH NEXT FROM Batches INTO @BatchPDbatch, @BatchPDnum;
	WHILE @@FETCH_STATUS = 0 AND @RxDrugPDnum > 0
	BEGIN
		IF @BatchPDnum >= @RxDrugPDnum
		BEGIN
			UPDATE InventoryDrug
			SET PDnum = (PDnum - @RxDrugPDnum)
			WHERE PDno = @RxDrugPDno AND PDbatch = @BatchPDbatch;
			SET @returnValue = @returnValue + @@error;
			SET @RxDrugPDnum = 0;
		END
		ELSE
		BEGIN
			SET @RxDrugPDnum = @RxDrugPDnum - @BatchPDnum;
			UPDATE InventoryDrug
			SET PDnum = 0
			WHERE PDno = @RxDrugPDno AND PDbatch = @BatchPDbatch;
			SET @returnValue = @returnValue + @@error;
		END
		FETCH NEXT FROM Batches INTO @BatchPDbatch, @BatchPDnum;
	END
	CLOSE Batches
	DEALLOCATE Batches
	FETCH NEXT FROM RxDrugs INTO @RxDrugPDno, @RxDrugPDnum;
END
CLOSE RxDrugs
DEALLOCATE RxDrugs
SET @returnValue = @returnValue + @@error;
UPDATE Prescription
SET Nno = @Nno, Htime = @Htime, Pstate = 1
WHERE Pno = @Pno;
SET @returnValue = @returnValue + @@error;
COMMIT TRAN

GO

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO Admin(Ano, Aname, Asex, Aage, Apwd) VALUES('admin0001', '李勇', 1, 25, 'admin0001');
INSERT INTO Admin(Ano, Aname, Asex, Aage, Apwd) VALUES('admin0002', '刘晨', 0, 28, 'admin0002');
INSERT INTO Admin(Ano, Aname, Asex, Aage, Apwd) VALUES('admin0003', '王敏', 0, 24, 'admin0003');
INSERT INTO Admin(Ano, Aname, Asex, Aage, Apwd) VALUES('admin0004', '张立', 1, 27, 'admin0004');
INSERT INTO Admin(Ano, Aname, Asex, Aage, Apwd) VALUES('admin0005', '张三', 1, 32, 'admin0005');

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO Doctor(Dno, Dname, Dsex, Dage, Dpwd) VALUES('doctor0001', '李四', 1, 39, 'doctor0001');
INSERT INTO Doctor(Dno, Dname, Dsex, Dage, Dpwd) VALUES('doctor0002', '王红', 0, 35, 'doctor0002');
INSERT INTO Doctor(Dno, Dname, Dsex, Dage, Dpwd) VALUES('doctor0003', '何琳', 0, 29, 'doctor0003');
INSERT INTO Doctor(Dno, Dname, Dsex, Dage, Dpwd) VALUES('doctor0004', '李敏', 0, 38, 'doctor0004');
INSERT INTO Doctor(Dno, Dname, Dsex, Dage, Dpwd) VALUES('doctor0005', '张辉', 1, 41, 'doctor0005');

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO Nurse(Nno, Nname, Nsex, Nage, Npwd) VALUES('nurse0001', '白磊', 1, 29, 'nurse0001');
INSERT INTO Nurse(Nno, Nname, Nsex, Nage, Npwd) VALUES('nurse0002', '杜鹃', 0, 35, 'nurse0002');
INSERT INTO Nurse(Nno, Nname, Nsex, Nage, Npwd) VALUES('nurse0003', '李强', 1, 32, 'nurse0003');
INSERT INTO Nurse(Nno, Nname, Nsex, Nage, Npwd) VALUES('nurse0004', '张飞', 1, 44, 'nurse0004');
INSERT INTO Nurse(Nno, Nname, Nsex, Nage, Npwd) VALUES('nurse0005', '黎敏', 0, 25, 'nurse0005');

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SYT0001', '遵义市意通医药有限责任公司', '遵义市沙河小区华南C2栋', '17811941621');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SDS0001', '贵州鼎圣药业有限公司', '遵义市红花岗区沙河路B号楼2楼', '17822557252');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SGT0001', '贵州国泰医药有限公司', '贵阳市富源北路35号', '17833553673');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SFT0001', '铜仁梵天药业有限公司', '铜仁市梵净山大道绿福宫小区', '17845457475');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SKYQD0001', '贵州科渝奇鼎医药有限公司', '贵阳市园林路1号', '17855257965');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SZX0001', '贵州振兴医药有限公司贵阳分公司', '贵阳市舒家寨富源中路261号', '17867568686');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SGYKG0001', '国药控股贵州有限公司', '贵阳国家高新技术产业开发区金阳科技产业园', '17837785477');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SXZT0001', '铜仁新中太药业有限公司', '铜仁市文笔路25号', '17880257080');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SYC0001', '贵州省药材公司', '贵阳市富源北路22号A区', '17859030598');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('STJ0001', '江阴天江药业有限公司', '江阴市经济开发区秦望山路8号', '17829486254');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('STY0001', '石阡县天佑中西药有限公司', '石阡县汤山镇河西农贸市场', '17815309574');
INSERT INTO Supplier(Sno, Sname, Saddr, Sphone)
	VALUES('SHY0001', '贵州弘一医药有限责任公司', '贵阳市青年路70号', '17816037460');

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H31020838', '阿莫西林胶囊', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20043730', '氨苄西林钠', 120);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H32021306', '青霉素钠', 90);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H19993751', '磷霉素钠', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20181082', '利伐沙班片', 270);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H31020892', '头孢拉定胶囊', 120);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H10910034', '头孢曲松钠', 90);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20153143', '头孢吡肟', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20023788', '头孢噻肟钠', 480);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z20054523', '骨筋丸胶囊', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z51020341', '复方穿心莲片', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z20083397', '四季感冒片', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z34020775', '午时茶颗粒', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z63020270', '十三味马钱子丸', 720);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H41024386', '氯芬黄敏片', 540);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z20025728', '痫愈胶囊', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20171255', '地高辛', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('J20180016', '替米沙坦片', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('J20030013', '噻奈普汀片', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('Z20120003', '复方樟薄软膏', 720);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20171253', '利血平', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('J20171070', '克拉霉素片', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('J20160100', '复方消化酶片', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('HC20160033', '愈创罂粟待因片', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20160566', '伏格列波糖', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('J20160051', '氧氟沙星眼膏', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('HC20160015', '莫匹罗星软膏', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20160144', '草木犀流浸液片', 360);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('H20140802', '复合维生素片', 180);
INSERT INTO Drug(PDno, PDname, PDlife) VALUES('HC20160010', '舍雷肽酶肠溶片', 360);

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H31020838', '2019-07-20', 15, 'SYT0001', 'admin0001', '2019-07-23 10:13:34.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H31020838', '2019-11-25', 273, 'SKYQD0001', 'admin0002', '2019-11-27 13:59:53.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20043730', '2019-09-18', 32, 'SDS0001', 'admin0001', '2019-09-21 10:28:23.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20043730', '2019-11-27', 524, 'SFT0001', 'admin0003', '2019-11-30 15:25:22.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H32021306', '2019-10-17', 9, 'SFT0001', 'admin0003', '2019-10-19 16:45:21.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H32021306', '2019-11-23', 27, 'SKYQD0001', 'admin0002', '2019-11-27 10:34:26.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H19993751', '2019-06-01', 89, 'SFT0001', 'admin0002', '2019-06-03 16:45:39.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H19993751', '2019-10-15', 371, 'SHY0001', 'admin0003', '2019-10-17 09:51:13.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20181082', '2019-04-06', 16, 'STJ0001', 'admin0005', '2019-04-08 16:05:38.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20181082', '2019-06-29', 305, 'SKYQD0001', 'admin0001', '2019-07-03 15:41:37.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H31020892', '2019-09-07', 27, 'SZX0001', 'admin0003', '2019-09-10 10:30:30.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H31020892', '2019-09-27', 412, 'STY0001', 'admin0001', '2019-09-29 11:43:54.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H31020892', '2019-12-07', 357, 'SFT0001', 'admin0002', '2019-12-09 11:20:54.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H10910034', '2019-10-05', 36, 'SGYKG0001', 'admin0004', '2019-10-06 10:36:55.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H10910034', '2019-12-16', 205, 'STY0001', 'admin0005', '2019-12-17 09:35:19.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20153143', '2019-08-03', 3, 'SXZT0001', 'admin0004', '2019-08-05 10:23:16.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20153143', '2019-11-05', 405, 'SZX0001', 'admin0003', '2019-11-09 14:09:17.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20023788', '2018-09-22', 13, 'SYC0001', 'admin0004', '2018-09-23 14:06:45.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20023788', '2019-11-21', 165, 'SYC0001', 'admin0005', '2019-11-25 11:53:51.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20054523', '2019-07-02', 5, 'SFT0001', 'admin0003', '2019-07-03 15:29:42.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20054523', '2019-09-21', 15, 'SZX0001', 'admin0005', '2019-09-25 17:35:23.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20054523', '2019-11-06', 517, 'SZX0001', 'admin0002', '2019-11-08 14:25:12.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z51020341', '2019-01-15', 14, 'SGT0001', 'admin0005', '2019-01-18 08:25:22.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z51020341', '2019-11-10', 306, 'SFT0001', 'admin0001', '2019-11-15 15:16:29.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20083397', '2019-11-25', 513, 'SHY0001', 'admin0001', '2019-11-30 14:35:02.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z34020775', '2019-07-12', 4, 'SGYKG0001', 'admin0004', '2019-07-13 09:11:35.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z34020775', '2019-11-25', 25, 'SZX0001', 'admin0003', '2019-12-01 15:46:02.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z63020270', '2019-03-29', 3, 'SHY0001', 'admin0004', '2019-04-02 16:47:32.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z63020270', '2019-12-01', 224, 'STJ0001', 'admin0004', '2019-12-04 08:25:32.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H41024386', '2019-05-07', 35, 'SHY0001', 'admin0003', '2019-05-08 09:22:55.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H41024386', '2019-12-02', 313, 'SGT0001', 'admin0005', '2019-12-05 15:56:22.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20025728', '2019-05-03', 10, 'SGYKG0001', 'admin0004', '2019-05-04 15:19:01.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20025728', '2019-10-05', 109, 'STJ0001', 'admin0002', '2019-10-09 10:45:06.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20171255', '2019-08-11', 5, 'SGYKG0001', 'admin0001', '2019-08-13 11:16:22.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20171255', '2019-11-05', 279, 'STJ0001', 'admin0001', '2019-11-06 08:43:04.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20180016', '2019-03-05', 16, 'STY0001', 'admin0004', '2019-03-06 13:56:17.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20180016', '2019-09-29', 230, 'SYC0001', 'admin0005', '2019-10-12 15:03:14.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20030013', '2019-08-16', 19, 'STY0001', 'admin0003', '2019-08-19 12:36:59.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20030013', '2019-12-13', 234, 'SXZT0001', 'admin0004', '2019-12-14 09:31:09.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20120003', '2018-02-15', 3, 'SHY0001', 'admin0004', '2018-02-18 11:07:57.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20120003', '2019-05-03', 5, 'SDS0001', 'admin0002', '2019-05-06 16:39:18.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('Z20120003', '2019-11-13', 32, 'SYT0001', 'admin0001', '2019-11-18 15:22:07.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20171253', '2019-07-15', 3, 'SHY0001', 'admin0002', '2019-07-17 16:03:46.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20171253', '2019-12-13', 85, 'SGYKG0001', 'admin0001', '2019-12-15 15:05:50.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20171070', '2019-04-05', 13, 'SXZT0001', 'admin0003', '2019-04-06 16:11:18.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20171070', '2019-10-05', 418, 'SZX0001', 'admin0001', '2019-10-06 09:04:36.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20160100', '2019-09-13', 39, 'SGYKG0001', 'admin0002', '2019-09-15 14:55:34.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('HC20160033', '2019-08-31', 76, 'STY0001', 'admin0005', '2019-09-03 13:53:12.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('HC20160033', '2019-12-05', 109, 'SDS0001', 'admin0004', '2019-12-11 15:03:24.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20160566', '2019-07-13', 5, 'SKYQD0001', 'admin0001', '2019-07-14 16:05:06.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20160566', '2019-09-16', 28, 'SXZT0001', 'admin0002', '2019-09-18 14:04:06.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20160051', '2019-02-03', 23, 'SZX0001', 'admin0005', '2019-02-04 13:17:36.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('J20160051', '2019-10-13', 160, 'SXZT0001', 'admin0003', '2019-10-24 08:06:13.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('HC20160015', '2019-03-14', 36, 'SFT0001', 'admin0001', '2019-03-19 13:45:30.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('HC20160015', '2019-12-01', 109, 'SHY0001', 'admin0004', '2019-12-03 11:15:36.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20160144', '2019-02-03', 6, 'SDS0001', 'admin0002', '2019-02-05 10:16:45.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20160144', '2019-09-16', 36, 'SDS0001', 'admin0001', '2019-09-17 16:51:15.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20140802', '2019-08-03', 49, 'STY0001', 'admin0005', '2019-08-07 10:45:56.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20140802', '2019-09-05', 93, 'SFT0001', 'admin0003', '2019-09-09 10:03:46.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('H20140802', '2019-12-14', 109, 'STY0001', 'admin0005', '2019-12-16 16:40:46.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('HC20160010', '2019-01-27', 19, 'STJ0001', 'admin0005', '2019-01-29 13:49:56.000');
INSERT INTO InventoryDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime)
	VALUES('HC20160010', '2019-12-15', 210, 'STJ0001', 'admin0001', '2019-12-19 08:42:16.000');

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H31020838', '2018-11-21', 17, 'SYT0001', 'admin0001', '2018-11-25 11:53:45.000',
														'admin0002', '2019-05-05 15:15:29.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H31020838', '2019-04-17', 13, 'SYT0001', 'admin0003', '2019-04-19 13:15:23.000',
														'admin0005', '2019-09-29 10:53:14.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20043730', '2018-11-05', 26, 'SDS0001', 'admin0002', '2018-11-09 14:29:16.000',
														'admin0003', '2019-02-23 10:59:05.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20043730', '2019-02-03', 17, 'SDS0001', 'admin0004', '2019-02-05 09:16:44.000',
														'admin0001', '2019-05-17 14:52:17.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20043730', '2019-05-07', 16, 'SDS0001', 'admin0001', '2019-05-11 15:13:29.000',
														'admin0005', '2019-08-23 17:09:22.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H32021306', '2018-01-08', 25, 'SGT0001', 'admin0002', '2018-01-11 10:36:55.000',
														'admin0005', '2018-04-01 12:05:53.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H32021306', '2018-03-28', 17, 'SGT0001', 'admin0002', '2018-03-31 12:03:05.000',
														'admin0005', '2018-06-19 15:53:01.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H32021306', '2018-05-31', 8, 'SGYKG0001', 'admin0003', '2018-06-03 17:06:57.000',
														'admin0001', '2018-08-22 13:07:35.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H32021306', '2018-08-09', 5, 'SXZT0001', 'admin0004', '2018-08-12 16:21:05.000',
														'admin0004', '2018-11-01 12:36:19.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H32021306', '2018-10-28', 25, 'SGYKG0001', 'admin0002', '2018-10-31 10:29:50.000',
														'admin0003', '2019-01-19 13:54:56.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H32021306', '2019-01-07', 19, 'SFT0001', 'admin0002', '2019-01-11 13:36:56.000',
														'admin0005', '2019-03-27 12:13:15.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H19993751', '2018-06-01', 3, 'SFT0001', 'admin0004', '2018-06-10 10:30:22.000',
														'admin0002', '2019-05-10 16:17:05.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H19993751', '2018-11-13', 51, 'STJ0001', 'admin0003', '2018-11-16 10:16:03.000',
														'admin0002', '2019-10-15 14:27:35.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20181082', '2018-03-15', 15, 'SKYQD0001', 'admin0003', '2018-03-25 09:16:30.000',
														'admin0004', '2018-12-05 11:05:06.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20181082', '2019-01-07', 39, 'SHY0001', 'admin0003', '2019-01-13 11:37:43.000',
														'admin0005', '2019-09-28 13:47:09.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20181082', '2019-03-09', 27, 'SKYQD0001', 'admin0003', '2019-03-15 16:13:10.000',
														'admin0005', '2019-11-21 15:08:15.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H31020892', '2018-06-01', 9, 'SGT0001', 'admin0004', '2018-06-10 16:45:39.000',
														'admin0004', '2018-09-24 13:59:15.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H31020892', '2018-09-11', 16, 'SGT0001', 'admin0001', '2018-09-13 10:03:19.000',
														'admin0003', '2018-12-31 09:29:53.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H31020892', '2018-12-23', 21, 'SDS0001', 'admin0005', '2018-12-27 15:34:09.000',
														'admin0001', '2019-04-14 13:36:05.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H31020892', '2019-04-05', 3, 'SYT0001', 'admin0001', '2019-04-08 16:06:37.000',
														'admin0005', '2019-09-29 10:35:37.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H10910034', '2018-09-30', 8, 'SGYKG0001', 'admin0004', '2018-10-10 15:05:26.000',
														'admin0001', '2018-12-24 09:16:55.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H10910034', '2018-12-13', 63, 'SGT0001', 'admin0005', '2018-12-15 15:26:30.000',
														'admin0003', '2019-03-03 14:36:05.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H10910034', '2019-05-22', 15, 'SKYQD0001', 'admin0002', '2019-05-24 16:04:06.000',
														'admin0003', '2019-08-14 09:56:50.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H10910034', '2019-09-23', 29, 'SKYQD0001', 'admin0001', '2019-09-26 10:53:26.000',
														'admin0001', '2019-12-17 08:56:08.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20153143', '2018-08-18', 27, 'SXZT0001', 'admin0005', '2018-08-25 10:28:23.000',
														'admin0002', '2019-02-06 16:13:43.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20153143', '2018-12-27', 6, 'SKYQD0001', 'admin0001', '2018-12-28 09:54:06.000',
														'admin0002', '2019-06-13 15:13:47.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20023788', '2018-06-10', 5, 'SYC0001', 'admin0005', '2018-06-12 10:37:30.000',
														'admin0001', '2019-09-23 15:22:16.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z20054523', '2018-06-13', 7, 'SYC0001', 'admin0002', '2018-06-15 10:49:32.000',
														'admin0003', '2019-12-03 08:53:19.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z20054523', '2018-12-01', 23, 'STJ0001', 'admin0001', '2018-12-04 16:22:10.000',
														'admin0005', '2019-05-21 10:11:06.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z51020341', '2018-03-17', 39, 'STY0001', 'admin0003', '2018-03-20 11:39:43.000',
														'admin0004', '2019-03-02 15:02:14.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z20083397', '2018-06-10', 8, 'SGT0001', 'admin0002', '2018-06-11 09:32:46.000',
														'admin0002', '2019-05-24 08:52:36.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z34020775', '2018-08-23', 32, 'STY0001', 'admin0002', '2018-08-25 15:03:11.000',
														'admin0003', '2019-08-03 14:23:38.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z63020270', '2017-11-23', 24, 'SYT0001', 'admin0004', '2017-11-29 14:16:23.000',
														'admin0002', '2019-10-24 11:47:13.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H41024386', '2017-11-03', 6, 'SYT0001', 'admin0004', '2017-11-05 11:36:03.000',
														'admin0005', '2019-04-04 13:36:18.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H41024386', '2018-03-13', 20, 'SGT0001', 'admin0005', '2018-03-14 10:32:11.000',
														'admin0002', '2019-08-16 13:11:58.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20171255', '2018-12-05', 7, 'SDS0001', 'admin0001', '2018-12-07 12:09:34.000',
														'admin0003', '2019-05-21 10:29:06.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20171255', '2019-05-27', 27, 'SYC0001', 'admin0004', '2019-05-29 15:03:24.000',
														'admin0003', '2019-11-13 10:29:06.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20180016', '2018-04-11', 3, 'SKYQD0001', 'admin0001', '2018-04-13 16:37:34.000',
														'admin0003', '2019-03-14 15:20:16.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20180016', '2018-08-06', 21, 'SYC0001', 'admin0005', '2018-08-08 15:08:24.000',
														'admin0003', '2019-07-12 09:53:36.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20030013', '2018-03-17', 7, 'SHY0001', 'admin0005', '2018-03-19 15:03:24.000',
														'admin0003', '2018-09-08 10:29:06.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20030013', '2018-06-12', 33, 'SDS0001', 'admin0001', '2018-06-16 16:37:34.000',
														'admin0005', '2018-12-03 15:20:16.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20030013', '2018-09-26', 25, 'SYC0001', 'admin0005', '2018-09-28 15:08:24.000',
														'admin0003', '2019-03-10 09:53:36.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('Z20120003', '2017-12-31', 45, 'SZX0001', 'admin0003', '2018-01-02 13:59:04.000',
														'admin0005', '2019-11-25 08:56:16.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20171253', '2018-09-29', 1, 'SXZT0001', 'admin0004', '2018-09-30 13:58:28.000',
														'admin0003', '2019-03-13 09:53:36.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20171253', '2018-12-13', 22, 'SXZT0001', 'admin0001', '2018-12-14 17:09:04.000',
														'admin0005', '2019-05-26 08:16:18.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20171070', '2018-12-17', 2, 'SZX0001', 'admin0001', '2018-12-18 16:19:54.000',
														'admin0004', '2019-11-21 09:53:08.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20160100', '2018-08-17', 5, 'SZX0001', 'admin0002', '2018-08-18 17:06:36.000',
														'admin0001', '2019-02-05 13:57:46.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20160100', '2019-06-03', 38, 'SYT0001', 'admin0005', '2019-06-04 15:09:34.000',
														'admin0002', '2019-11-21 12:08:53.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('HC20160033', '2019-06-12', 82, 'SGT0001', 'admin0001', '2019-06-16 13:48:35.000',
														'admin0002', '2019-12-02 10:06:13.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20160566', '2018-02-17', 35, 'SHY0001', 'admin0002', '2018-02-21 14:05:26.000',
														'admin0001', '2019-08-02 16:27:06.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20160566', '2018-08-03', 3, 'SYT0001', 'admin0003', '2018-08-10 16:17:03.000',
														'admin0002', '2019-01-19 10:48:23.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20160566', '2018-12-29', 9, 'SXZT0001', 'admin0002', '2018-12-30 12:13:04.000',
														'admin0003', '2019-06-05 13:09:56.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20160566', '2019-05-07', 51, 'SYC0001', 'admin0002', '2019-05-09 12:03:29.000',
														'admin0005', '2019-10-22 16:19:26.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20160051', '2018-07-05', 5, 'SHY0001', 'admin0002', '2018-07-08 10:03:21.000',
														'admin0005', '2019-06-18 15:09:25.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('J20160051', '2018-12-24', 10, 'SYT0001', 'admin0005', '2018-12-25 13:53:28.000',
														'admin0002', '2019-12-02 16:19:27.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('HC20160015', '2018-12-15', 35, 'STY0001', 'admin0003', '2018-12-16 11:03:44.000',
														'admin0002', '2019-11-23 13:49:07.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20160144', '2018-11-03', 7, 'STJ0001', 'admin0004', '2018-11-04 10:53:38.000',
														'admin0002', '2019-10-17 11:18:27.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20160144', '2018-12-28', 8, 'SYC0001', 'admin0005', '2018-12-29 13:56:24.000',
														'admin0001', '2019-12-12 16:13:42.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('H20140802', '2018-11-30', 42, 'SYT0001', 'admin0001', '2018-12-01 15:34:20.000',
														'admin0001', '2019-05-20 17:09:32.000');
INSERT INTO DestroyedDrug(PDno, PDbatch, PDnum, Sno, SAno, Stime, DAno, Dtime)
	VALUES('HC20160010', '2018-12-10', 10, 'STY0001', 'admin0004', '2018-12-11 15:44:30.000',
														'admin0002', '2019-11-23 10:29:26.000');

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419901023', 'doctor0001', '2019-12-19 08:37:10.000', 'nurse0002', '2019-12-19 08:43:13.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419981102', 'doctor0002', '2019-12-19 09:22:19.000', 'nurse0003', '2019-12-19 09:28:33.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419971206', 'doctor0003', '2019-12-19 10:35:17.000', 'nurse0005', '2019-12-19 10:45:19.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419880516', 'doctor0004', '2019-12-19 11:42:10.000', 'nurse0004', '2019-12-19 11:51:52.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419760215', 'doctor0005', '2019-12-19 14:05:59.000', 'nurse0001', '2019-12-19 14:25:33.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419950916', 'doctor0001', '2019-12-19 15:43:18.000', 'nurse0005', '2019-12-19 15:52:46.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419910416', 'doctor0002', '2019-12-19 16:19:35.000', 'nurse0003', '2019-12-19 16:27:46.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419960730', 'doctor0003', '2019-12-19 17:27:45.000', 'nurse0004', '2019-12-19 17:36:32.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419921016', 'doctor0004', '2019-12-20 08:35:16.000', 'nurse0002', '2019-12-20 08:47:55.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419941016', 'doctor0005', '2019-12-20 09:35:16.000', 'nurse0001', '2019-12-20 09:49:13.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419871220', 'doctor0001', '2019-12-20 10:35:17.000', 'nurse0003', '2019-12-20 10:45:19.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419820517', 'doctor0002', '2019-12-20 11:36:10.000', 'nurse0002', '2019-12-20 11:42:52.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419750215', 'doctor0003', '2019-12-20 14:05:59.000', 'nurse0005', '2019-12-20 14:25:33.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419800919', 'doctor0004', '2019-12-20 15:28:18.000', 'nurse0001', '2019-12-20 15:46:46.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419860413', 'doctor0005', '2019-12-20 16:19:35.000', 'nurse0004', '2019-12-20 16:25:46.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419830730', 'doctor0001', '2019-12-20 17:27:45.000', 'nurse0004', '2019-12-20 17:39:32.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419841016', 'doctor0002', '2019-12-21 08:35:16.000', 'nurse0005', '2019-12-21 08:47:55.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419721115', 'doctor0003', '2019-12-21 09:35:16.000', 'nurse0003', '2019-12-21 09:49:13.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419731208', 'doctor0004', '2019-12-21 10:35:17.000', 'nurse0001', '2019-12-21 10:45:19.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419850516', 'doctor0005', '2019-12-21 11:03:10.000', 'nurse0002', '2019-12-21 11:08:52.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419730215', 'doctor0001', '2019-12-21 14:05:59.000', 'nurse0003', '2019-12-21 14:25:33.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419690917', 'doctor0002', '2019-12-21 15:16:18.000', 'nurse0004', '2019-12-21 15:29:46.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419670419', 'doctor0003', '2019-12-21 16:19:35.000', 'nurse0005', '2019-12-21 16:35:46.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419660630', 'doctor0004', '2019-12-21 17:27:45.000', 'nurse0004', '2019-12-21 17:40:32.000', 1);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419680109', 'doctor0005', '2019-12-22 08:03:09.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419700928', 'doctor0001', '2019-12-22 08:05:25.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419880821', 'doctor0002', '2019-12-22 08:07:06.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419740413', 'doctor0003', '2019-12-22 08:09:35.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068419770516', 'doctor0004', '2019-12-22 08:13:14.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068420011204', 'doctor0005', '2019-12-22 08:15:11.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068420021106', 'doctor0001', '2019-12-22 08:17:57.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068420030227', 'doctor0002', '2019-12-22 08:19:36.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068420040316', 'doctor0003', '2019-12-22 08:21:22.000', null, null, 0);
INSERT INTO Prescription(Pid, Dno, Ptime, Nno, Htime, Pstate)
	VALUES('44068420051025', 'doctor0004', '2019-12-22 08:23:16.000', null, null, 0);

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

INSERT INTO PID(Pno, PDno, PDnum) VALUES(1, 'Z51020341', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(1, 'Z20025728', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(1, 'H20160566', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(1, 'J20160051', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(2, 'Z34020775', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(2, 'J20180016', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(2, 'J20160051', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(3, 'H10910034', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(3, 'H20153143', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(3, 'H20023788', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(4, 'H20043730', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(4, 'H32021306', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(4, 'HC20160015', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(5, 'H32021306', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(5, 'H20181082', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(5, 'HC20160033', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(5, 'J20160051', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(6, 'J20180016', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(6, 'H20140802', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(6, 'HC20160010', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(7, 'Z20054523', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(7, 'Z51020341', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(7, 'Z63020270', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(7, 'HC20160010', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(8, 'H31020892', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(8, 'H20153143', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(8, 'H20023788', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(9, 'H31020838', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(9, 'Z51020341', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(9, 'H41024386', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(9, 'J20180016', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(10, 'H20171255', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(10, 'J20030013', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(10, 'H20160144', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(10, 'H20160566', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(11, 'H20171255', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(11, 'J20180016', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(11, 'H20160144', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(12, 'J20030013', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(12, 'Z20120003', 6);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(12, 'H20160144', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(13, 'J20030013', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(13, 'Z20120003', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(13, 'H20171253', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(14, 'Z20083397', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(14, 'J20171070', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(14, 'J20160100', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(15, 'Z20054523', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(15, 'H20023788', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(15, 'J20171070', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(15, 'J20160100', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(16, 'J20171070', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(16, 'HC20160033', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(17, 'J20160100', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(17, 'H20160566', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(17, 'J20160051', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(18, 'H10910034', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(18, 'Z20025728', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(18, 'HC20160033', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(19, 'H31020838', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(19, 'H32021306', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(19, 'Z20025728', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(19, 'H20160566', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(20, 'H20181082', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(20, 'H20043730', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(20, 'HC20160015', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(21, 'H20181082', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(21, 'Z20054523', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(21, 'H41024386', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(21, 'J20030013', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(21, 'H20140802', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(22, 'H20153143', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(22, 'Z20054523', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(23, 'H31020838', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(23, 'H19993751', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(24, 'H31020892', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(24, 'Z63020270', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(24, 'J20160051', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(25, 'H20181082', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(25, 'Z20025728', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(26, 'J20180016', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(26, 'J20030013', 2);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(26, 'J20160051', 1);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(26, 'H20160144', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(27, 'H20043730', 5);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(27, 'H41024386', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(27, 'H20171253', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(28, 'H10910034', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(28, 'H20171253', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(29, 'H20171253', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(29, 'HC20160015', 4);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(29, 'H20160144', 3);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(30, 'H20140802', 7);
INSERT INTO PID(Pno, PDno, PDnum) VALUES(30, 'HC20160010', 1);
