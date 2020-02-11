package com.dims.service;

import java.util.List;

import com.dims.domain.Doctor;
import com.dims.domain.Drug;
import com.dims.domain.Prescription;
import com.dims.domain.User;

public interface IDoctorService {
	public Doctor login(User user); // 登录

	public int countUnsolvedRxs(); // 统计未处理处方数目

	public int countSolvedRxs(); // 统计已处理处方数目

	public int countMyPrescribeRxs(Doctor doctor); // 统计由该名医生开出的处方数目

	public List<Drug> queryAllDrugs(); // 查看药品库存列表

	public List<Doctor> queryAllDoctors(); // 查看医生列表

	public List<Prescription> queryAllUnsolvedRxs(); // 查看未处理处方列表

	public List<Prescription> queryAllSolvedRxs(); // 查看已处理处方列表

	public Prescription queryOneRx(Prescription rx); // 查看某一处方的具体明细

	public List<Drug> queryAllContainedDrugs(Prescription rx); // 查看某一处方包含的所有药品

	public int addNewRx(Prescription newRx); // 新增一条处方记录

	public int editRx(Prescription rx); // 修改一条处方记录

	public int queryOneDrugNum(Drug drug); // 查询某一药品的总库存数量

	public boolean existRxDrug(Prescription rx, Drug drug); // 判断某一处方是否已经存在某一药品

	public int addNewRxDrug(Prescription rx, Drug newDrug); // 为某一处方添加一种药品

	public int editRxDrug(Prescription rx, Drug drug); // 修改某一处方的某一药品

	public int deleteRx(Prescription rx); // 删除某一处方

	public int deleteRxDrug(Prescription rx, Drug drug); // 删除某一处方的某一药品

	public Doctor queryOneDoctor(Doctor doctor); // 查询某一医生的所有信息

	public List<Prescription> querySpecificDoctorRxs(Doctor doctor); // 查询某一医生开出的所有处方

	public int changeDpwd(String Dpwd, String Dno); // 修改登录密码
}
