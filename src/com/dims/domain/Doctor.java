package com.dims.domain;

import java.util.List;

public class Doctor { // 医生
	String Dno; // 编号
	String Dname; // 姓名
	boolean Dsex; // 性别 (1 为男，0 为女)
	int Dage; // 年龄
	String Dpwd; // 登陆密码
	List<Prescription> allRxs; // 由该医生开出的所有处方

	public String getDno() {
		return Dno;
	}

	public void setDno(String dno) {
		Dno = dno;
	}

	public String getDname() {
		return Dname;
	}

	public void setDname(String dname) {
		Dname = dname;
	}

	public boolean isDsex() {
		return Dsex;
	}

	public void setDsex(boolean dsex) {
		Dsex = dsex;
	}

	public int getDage() {
		return Dage;
	}

	public void setDage(int dage) {
		Dage = dage;
	}

	public String getDpwd() {
		return Dpwd;
	}

	public void setDpwd(String dpwd) {
		Dpwd = dpwd;
	}

	public List<Prescription> getAllRxs() {
		return allRxs;
	}

	public void setAllRxs(List<Prescription> allRxs) {
		this.allRxs = allRxs;
	}

	@Override
	public String toString() {
		return "Doctor [Dno=" + Dno + ", Dname=" + Dname + ", Dsex=" + Dsex + ", Dage=" + Dage + ", Dpwd=" + Dpwd
				+ ", allRxs=" + allRxs + "]";
	}
}
