package com.dims.domain;

import java.util.Date;
import java.util.List;

public class Prescription {
	int Pno; // 编号
	String Pid; // 病人身份证号码
	String Dno; // 开出医生编号
	Date Ptime; // 开出时间
	String Nno; // 处理护士编号
	Date Htime; // 处理时间
	boolean Pstate; // 状态 (1 为已处理，0 为未处理)
	List<Drug> Drugs; // 处方包含的药品

	public int getPno() {
		return Pno;
	}

	public void setPno(int pno) {
		Pno = pno;
	}

	public String getPid() {
		return Pid;
	}

	public void setPid(String pid) {
		Pid = pid;
	}

	public String getDno() {
		return Dno;
	}

	public void setDno(String dno) {
		Dno = dno;
	}

	public Date getPtime() {
		return Ptime;
	}

	public void setPtime(Date ptime) {
		Ptime = ptime;
	}

	public String getNno() {
		return Nno;
	}

	public void setNno(String nno) {
		Nno = nno;
	}

	public Date getHtime() {
		return Htime;
	}

	public void setHtime(Date htime) {
		Htime = htime;
	}

	public boolean isPstate() {
		return Pstate;
	}

	public void setPstate(boolean pstate) {
		Pstate = pstate;
	}

	public List<Drug> getDrugs() {
		return Drugs;
	}

	public void setDrugs(List<Drug> drugs) {
		Drugs = drugs;
	}

	@Override
	public String toString() {
		return "Prescription [Pno=" + Pno + ", Pid=" + Pid + ", Dno=" + Dno + ", Ptime=" + Ptime + ", Nno=" + Nno
				+ ", Htime=" + Htime + ", Pstate=" + Pstate + ", Drugs=" + Drugs + "]";
	}
}
