package com.dims.domain;

import java.util.List;

public class Admin { // 库存管理员
	String Ano; // 编号
	String Aname; // 姓名
	boolean Asex; // 性别 (1 为男，0 为女)
	int Aage; // 年龄
	String Apwd; // 登陆密码
	List<DestroyedDrug> allPDbatches; // 由该库存管理员负责的所有批次 (包括库存批次和已销毁批次、包括入库和出库)

	public String getAno() {
		return Ano;
	}

	public void setAno(String ano) {
		Ano = ano;
	}

	public String getAname() {
		return Aname;
	}

	public void setAname(String aname) {
		Aname = aname;
	}

	public boolean isAsex() {
		return Asex;
	}

	public void setAsex(boolean asex) {
		Asex = asex;
	}

	public int getAage() {
		return Aage;
	}

	public void setAage(int aage) {
		Aage = aage;
	}

	public String getApwd() {
		return Apwd;
	}

	public void setApwd(String apwd) {
		Apwd = apwd;
	}

	public List<DestroyedDrug> getAllPDbatches() {
		return allPDbatches;
	}

	public void setAllPDbatches(List<DestroyedDrug> allPDbatches) {
		this.allPDbatches = allPDbatches;
	}

	@Override
	public String toString() {
		return "Admin [Ano=" + Ano + ", Aname=" + Aname + ", Asex=" + Asex + ", Aage=" + Aage + ", Apwd=" + Apwd
				+ ", allPDbatches=" + allPDbatches + "]";
	}
}
