package com.dims.domain;

import java.util.List;

public class Nurse { // 发药处护士
	String Nno; // 编号
	String Nname; // 姓名
	boolean Nsex; // 性别 (1 为男，0 为女)
	int Nage; // 年龄
	String Npwd; // 登录密码
	List<Prescription> allRxs; // 由该护士处理的所有处方

	public String getNno() {
		return Nno;
	}

	public void setNno(String nno) {
		Nno = nno;
	}

	public String getNname() {
		return Nname;
	}

	public void setNname(String nname) {
		Nname = nname;
	}

	public boolean isNsex() {
		return Nsex;
	}

	public void setNsex(boolean nsex) {
		Nsex = nsex;
	}

	public int getNage() {
		return Nage;
	}

	public void setNage(int nage) {
		Nage = nage;
	}

	public String getNpwd() {
		return Npwd;
	}

	public void setNpwd(String npwd) {
		Npwd = npwd;
	}

	public List<Prescription> getAllRxs() {
		return allRxs;
	}

	public void setAllRxs(List<Prescription> allRxs) {
		this.allRxs = allRxs;
	}

	@Override
	public String toString() {
		return "Nurse [Nno=" + Nno + ", Nname=" + Nname + ", Nsex=" + Nsex + ", Nage=" + Nage + ", Npwd=" + Npwd
				+ ", allRxs=" + allRxs + "]";
	}
}
