package com.dims.service;

import java.util.List;

import com.dims.domain.Admin;
import com.dims.domain.DestroyedDrug;
import com.dims.domain.Drug;
import com.dims.domain.InventoryDrug;
import com.dims.domain.Supplier;
import com.dims.domain.User;

public interface IAdminService {
	public Admin login(User user); // 登录

	public int countLowInventoryDrugs(); // 统计量少的库存药品种数

	public int countClose2ExpiryPDbatches(); // 统计临期库存药品批数

	public int countInventoryDrugs(); // 统计库存药品种数

	public int countInventoryPDbatches(); // 统计库存药品批数

	public int countDestroyedPDbatches(); // 统计销毁药品批数

	public int countMyInventoryPDbatches(Admin amdin); // 统计由该名库存管理员入库的库存药品批数

	public int countMyPDbatches(Admin admin); // 统计由该名库存管理员入库的药品总批数

	public int countMyDestoryedPDbatches(Admin admin); // 统计由该名库存管理员销毁 (出库) 的销毁药品批数

	public List<Drug> queryAllDrugs(); // 查看药品库存列表

	public Drug queryOneDrug(Drug drug); // 查看某一药品的所有信息

	public List<DestroyedDrug> querySpecificPDbatches(Drug drug); // 查看某一药品的所有批次 (包括库存批次和已销毁批次)

	public List<DestroyedDrug> querySpecificSupplierPDbatches(Supplier supplier); // 查看某一供应商提供的所有批次 (包括库存批次和已销毁批次)

	public List<DestroyedDrug> querySpecificAdminPDbatches(Admin admin); // 查看某一库存管理员负责的所有批次 (包括库存批次和已销毁批次、包括入库和出库)

	public List<InventoryDrug> querySpecificInventoryPDbatches(Drug drug); // 查看某一药品的所有库存批次

	public InventoryDrug queryOnePDbatch(InventoryDrug pdbatch); // 查看某一药品批次的所有信息

	public List<DestroyedDrug> queryAllDestroyedPDbatches(); // 查看已销毁药品批次列表

	public List<DestroyedDrug> querySpecificDestroyedPDbatches(Drug drug); // 参看某一药品的所有已销毁批次

	public List<Drug> queryLowInventoryDrugs(); // 查看量少的库存药品列表

	public List<InventoryDrug> queryClose2ExpiryPDbatches(); // 查看临期库存药品列表

	public List<Supplier> queryAllSuppliers(); // 查看药品供应商列表

	public Supplier queryOneSupplier(Supplier supplier); // 查看某一药品供应商的所有信息

	public int addNewSupplier(Supplier newSupplier); // 添加一条供应商信息记录

	public int editSupplier(Supplier supplier); // 修改一条供应商信息记录

	public List<Admin> queryAllAdmins(); // 查看库存管理员列表

	public Admin queryOneAdmin(Admin admin); // 查看某一库存管理员的所有信息

	public int addNewPDbatch(InventoryDrug newPDbatch); // 药品入库 / 添加一条库存药品记录

	public int editPDbatch(InventoryDrug pdbatch); // 修改一条库存药品记录

	public int destroyPDbatch(DestroyedDrug pdbatch); // 销毁一批库存药品批次

	public int changeApwd(String Apwd, String Ano); // 修改登录密码
}
