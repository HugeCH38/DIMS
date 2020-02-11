package com.dims.domain;

import java.util.List;

public class Supplier { // 供应商
	String Sno; // 编号
	String Sname; // 名称
	String Saddr; // 地址
	String Sphone; // 电话
	List<DestroyedDrug> allPDbatches; // 由该供应商提供的所有批次 (包括库存批次和已销毁批次)

	public String getSno() {
		return Sno;
	}

	public void setSno(String sno) {
		Sno = sno;
	}

	public String getSname() {
		return Sname;
	}

	public void setSname(String sname) {
		Sname = sname;
	}

	public String getSaddr() {
		return Saddr;
	}

	public void setSaddr(String saddr) {
		Saddr = saddr;
	}

	public String getSphone() {
		return Sphone;
	}

	public void setSphone(String sphone) {
		Sphone = sphone;
	}

	public List<DestroyedDrug> getAllPDbatches() {
		return allPDbatches;
	}

	public void setAllPDbatches(List<DestroyedDrug> allPDbatches) {
		this.allPDbatches = allPDbatches;
	}

	@Override
	public String toString() {
		return "Supplier [Sno=" + Sno + ", Sname=" + Sname + ", Saddr=" + Saddr + ", Sphone=" + Sphone
				+ ", allPDbatches=" + allPDbatches + "]";
	}
}
