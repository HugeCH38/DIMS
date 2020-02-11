package com.dims.domain;

import java.util.Date;

public class DestroyedDrug { // 已销毁药品
	String PDno; // 编号
	String PDname; // 名称
	int PDlife; // 保质期 (天数)
	Date PDbatch; // 批次 (生产日期)
	int PDnum; // 数量
	String Sno; // 供应商编号
	String SAno; // 入库库存管理员编号
	Date Stime; // 入库时间
	String DAno; // 销毁库存管理员编号
	Date Dtime; // 销毁时间
	int Rdays; // 距离保质期剩余的天数

	public String getPDno() {
		return PDno;
	}

	public void setPDno(String pDno) {
		PDno = pDno;
	}

	public String getPDname() {
		return PDname;
	}

	public void setPDname(String pDname) {
		PDname = pDname;
	}

	public int getPDlife() {
		return PDlife;
	}

	public void setPDlife(int pDlife) {
		PDlife = pDlife;
	}

	public Date getPDbatch() {
		return PDbatch;
	}

	public void setPDbatch(Date pDbatch) {
		PDbatch = pDbatch;
	}

	public int getPDnum() {
		return PDnum;
	}

	public void setPDnum(int pDnum) {
		PDnum = pDnum;
	}

	public String getSno() {
		return Sno;
	}

	public void setSno(String sno) {
		Sno = sno;
	}

	public String getSAno() {
		return SAno;
	}

	public void setSAno(String sAno) {
		SAno = sAno;
	}

	public Date getStime() {
		return Stime;
	}

	public void setStime(Date stime) {
		Stime = stime;
	}

	public String getDAno() {
		return DAno;
	}

	public void setDAno(String dAno) {
		DAno = dAno;
	}

	public Date getDtime() {
		return Dtime;
	}

	public void setDtime(Date dtime) {
		Dtime = dtime;
	}

	public int getRdays() {
		return Rdays;
	}

	public void setRdays(int rdays) {
		Rdays = rdays;
	}

	@Override
	public String toString() {
		return "DestroyedDrug [PDno=" + PDno + ", PDname=" + PDname + ", PDlife=" + PDlife + ", PDbatch=" + PDbatch
				+ ", PDnum=" + PDnum + ", Sno=" + Sno + ", SAno=" + SAno + ", Stime=" + Stime + ", DAno=" + DAno
				+ ", Dtime=" + Dtime + ", Rdays=" + Rdays + "]";
	}
}
