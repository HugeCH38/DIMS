package com.dims.domain;

import java.util.List;

public class Drug { // 药品
	String PDno; // 编号
	String PDname; // 名称
	int PDlife; // 保质期 (天数)
	int PDnum; // 数量
	List<InventoryDrug> inventoryDrugs; // 库存药品批次
	List<DestroyedDrug> destroyedDrugs; // 已销毁药品批次
	List<DestroyedDrug> allPDbatches; // 所有批次 (包括库存批次和已销毁批次)
	boolean existClose2ExpiryPDbatch; // 是否存在临期药品批次

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

	public int getPDnum() {
		return PDnum;
	}

	public void setPDnum(int pDnum) {
		PDnum = pDnum;
	}

	public List<InventoryDrug> getInventoryDrugs() {
		return inventoryDrugs;
	}

	public void setInventoryDrugs(List<InventoryDrug> inventoryDrugs) {
		this.inventoryDrugs = inventoryDrugs;
	}

	public List<DestroyedDrug> getDestroyedDrugs() {
		return destroyedDrugs;
	}

	public void setDestroyedDrugs(List<DestroyedDrug> destroyedDrugs) {
		this.destroyedDrugs = destroyedDrugs;
	}

	public List<DestroyedDrug> getAllPDbatches() {
		return allPDbatches;
	}

	public void setAllPDbatches(List<DestroyedDrug> allPDbatches) {
		this.allPDbatches = allPDbatches;
	}

	public boolean isExistClose2ExpiryPDbatch() {
		return existClose2ExpiryPDbatch;
	}

	public void setExistClose2ExpiryPDbatch(boolean existClose2ExpiryPDbatch) {
		this.existClose2ExpiryPDbatch = existClose2ExpiryPDbatch;
	}

	@Override
	public String toString() {
		return "Drug [PDno=" + PDno + ", PDname=" + PDname + ", PDlife=" + PDlife + ", PDnum=" + PDnum
				+ ", inventoryDrugs=" + inventoryDrugs + ", destroyedDrugs=" + destroyedDrugs + ", allPDbatches="
				+ allPDbatches + ", existClose2ExpiryPDbatch=" + existClose2ExpiryPDbatch + "]";
	}
}
