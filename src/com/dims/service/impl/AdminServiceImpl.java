package com.dims.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dims.domain.Admin;
import com.dims.domain.DestroyedDrug;
import com.dims.domain.Drug;
import com.dims.domain.InventoryDrug;
import com.dims.domain.Supplier;
import com.dims.domain.User;
import com.dims.mapper.AdminMapper;
import com.dims.service.IAdminService;

@Service
public class AdminServiceImpl implements IAdminService {
	@Autowired
	AdminMapper adminMapper;

	@Override
	public Admin login(User user) { // 登录
		return adminMapper.login(user);
	}

	@Override
	public int countLowInventoryDrugs() { // 统计量少的库存药品种数
		return adminMapper.countLowInventoryDrugs();
	}

	@Override
	public int countClose2ExpiryPDbatches() { // 统计临期库存药品批数
		return adminMapper.countClose2ExpiryPDbatches();
	}

	@Override
	public int countInventoryDrugs() { // 统计库存药品种数
		return adminMapper.countInventoryDrugs();
	}

	@Override
	public int countInventoryPDbatches() { // 统计库存药品批数
		return adminMapper.countInventoryPDbatches();
	}

	@Override
	public int countDestroyedPDbatches() { // 统计销毁药品批数
		return adminMapper.countDestroyedPDbatches();
	}

	@Override
	public int countMyInventoryPDbatches(Admin amdin) { // 统计由该名库存管理员入库的库存药品批数
		return adminMapper.countMyInventoryPDbatches(amdin);
	}

	@Override
	public int countMyPDbatches(Admin admin) { // 统计由该名库存管理员入库的药品总批数
		return adminMapper.countMyPDbatches(admin);
	}

	@Override
	public int countMyDestoryedPDbatches(Admin admin) { // 统计由该名库存管理员销毁 (出库) 的销毁药品批数
		return adminMapper.countMyDestoryedPDbatches(admin);
	}

	@Override
	public List<Drug> queryAllDrugs() { // 查看药品库存列表
		return adminMapper.queryAllDrugs();
	}

	@Override
	public Drug queryOneDrug(Drug drug) { // 查看某一药品的所有信息
		return adminMapper.queryOneDrug(drug);
	}

	@Override
	public List<DestroyedDrug> querySpecificPDbatches(Drug drug) { // 查看某一药品的所有批次 (包括库存批次和已销毁批次)
		return adminMapper.querySpecificPDbatches(drug);
	}

	@Override
	public List<DestroyedDrug> querySpecificSupplierPDbatches(Supplier supplier) { // 查看某一供应商提供的所有批次 (包括库存批次和已销毁批次)
		return adminMapper.querySpecificSupplierPDbatches(supplier);
	}

	@Override
	public List<DestroyedDrug> querySpecificAdminPDbatches(Admin admin) { // 查看某一库存管理员负责的所有批次 (包括库存批次和已销毁批次、包括入库和出库)
		return adminMapper.querySpecificAdminPDbatches(admin);
	}

	@Override
	public List<InventoryDrug> querySpecificInventoryPDbatches(Drug drug) { // 查看某一药品的所有库存批次
		return adminMapper.querySpecificInventoryPDbatches(drug);
	}

	@Override
	public InventoryDrug queryOnePDbatch(InventoryDrug pdbatch) { // 查看某一药品批次的所有信息
		return adminMapper.queryOnePDbatch(pdbatch);
	}

	@Override
	public List<DestroyedDrug> queryAllDestroyedPDbatches() { // 查看已销毁药品批次列表
		return adminMapper.queryAllDestroyedPDbatches();
	}

	@Override
	public List<DestroyedDrug> querySpecificDestroyedPDbatches(Drug drug) { // 参看某一药品的所有已销毁批次
		return adminMapper.querySpecificDestroyedPDbatches(drug);
	}

	@Override
	public List<Drug> queryLowInventoryDrugs() { // 查看量少的库存药品列表
		return adminMapper.queryLowInventoryDrugs();
	}

	@Override
	public List<InventoryDrug> queryClose2ExpiryPDbatches() { // 查看临期库存药品列表
		return adminMapper.queryClose2ExpiryPDbatches();
	}

	@Override
	public List<Supplier> queryAllSuppliers() { // 查看药品供应商列表
		return adminMapper.queryAllSuppliers();
	}

	@Override
	public Supplier queryOneSupplier(Supplier supplier) { // 查看某一药品供应商的所有信息
		return adminMapper.queryOneSupplier(supplier);
	}

	@Override
	public int addNewSupplier(Supplier newSupplier) { // 添加一条供应商信息记录
		int returnValue = 0;

		try {
			returnValue = adminMapper.addNewSupplier(newSupplier);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int editSupplier(Supplier supplier) { // 修改一条供应商信息记录
		int returnValue = 0;

		try {
			returnValue = adminMapper.editSupplier(supplier);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public List<Admin> queryAllAdmins() { // 查看库存管理员列表
		return adminMapper.queryAllAdmins();
	}

	@Override
	public Admin queryOneAdmin(Admin admin) { // 查看某一库存管理员的所有信息
		return adminMapper.queryOneAdmin(admin);
	}

	@Override
	public int addNewPDbatch(InventoryDrug newPDbatch) { // 药品入库 / 添加一条库存药品记录
		int returnValue = 0;

		try {
			returnValue = adminMapper.addNewPDbatch(newPDbatch);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int editPDbatch(InventoryDrug pdbatch) { // 修改一条库存药品记录
		int returnValue = 0;

		try {
			returnValue = adminMapper.editPDbatch(pdbatch);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int destroyPDbatch(DestroyedDrug pdbatch) { // 销毁一批库存药品批次
		int returnValue = 0;

		try {
			returnValue = adminMapper.destroyPDbatch(pdbatch);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return returnValue;
	}

	@Override
	public int changeApwd(String Apwd, String Ano) { // 修改登录密码
		int returnValue = 0;

		try {
			returnValue = adminMapper.changeApwd(Apwd, Ano);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}
}
