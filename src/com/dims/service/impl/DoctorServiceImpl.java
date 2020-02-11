package com.dims.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dims.domain.Doctor;
import com.dims.domain.Drug;
import com.dims.domain.Prescription;
import com.dims.domain.User;
import com.dims.mapper.DoctorMapper;
import com.dims.service.IDoctorService;

@Service
public class DoctorServiceImpl implements IDoctorService {
	@Autowired
	DoctorMapper doctorMapper;

	@Override
	public Doctor login(User user) { // 登录
		return doctorMapper.login(user);
	}

	@Override
	public int countUnsolvedRxs() { // 统计未处理处方数目
		return doctorMapper.countUnsolvedRxs();
	}

	@Override
	public int countSolvedRxs() { // 统计已处理处方数目
		return doctorMapper.countSolvedRxs();
	}

	@Override
	public int countMyPrescribeRxs(Doctor doctor) { // 统计由该名医生开出的处方数目
		return doctorMapper.countMyPrescribeRxs(doctor);
	}

	@Override
	public List<Drug> queryAllDrugs() { // 查看药品库存列表
		return doctorMapper.queryAllDrugs();
	}

	@Override
	public List<Doctor> queryAllDoctors() { // 查看医生列表
		return doctorMapper.queryAllDoctors();
	}

	@Override
	public List<Prescription> queryAllUnsolvedRxs() { // 查看未处理处方列表
		return doctorMapper.queryAllUnsolvedRxs();
	}

	@Override
	public List<Prescription> queryAllSolvedRxs() { // 查看已处理处方列表
		return doctorMapper.queryAllSolvedRxs();
	}

	@Override
	public Prescription queryOneRx(Prescription rx) { // 查看某一处方的具体明细
		return doctorMapper.queryOneRx(rx);
	}

	@Override
	public List<Drug> queryAllContainedDrugs(Prescription rx) { // 查看某一处方包含的所有药品
		return doctorMapper.queryAllContainedDrugs(rx);
	}

	@Override
	public int addNewRx(Prescription newRx) { // 新增一条处方记录
		int returnValue = 0;

		try {
			returnValue = doctorMapper.addNewRx(newRx);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int editRx(Prescription rx) { // 修改一条处方记录
		int returnValue = 0;

		try {
			returnValue = doctorMapper.editRx(rx);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int queryOneDrugNum(Drug drug) { // 查询某一药品的总库存数量
		return doctorMapper.queryOneDrugNum(drug);
	}

	@Override
	public boolean existRxDrug(Prescription rx, Drug drug) { // 判断某一处方是否已经存在某一药品
		if (doctorMapper.queryRxDrug(rx, drug) != 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public int addNewRxDrug(Prescription rx, Drug newDrug) { // 为某一处方添加一种药品
		int returnValue = 1;

		try {
			doctorMapper.addNewRxDrug(rx, newDrug);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int editRxDrug(Prescription rx, Drug drug) { // 修改某一处方的某一药品
		int returnValue = 0;

		try {
			returnValue = doctorMapper.editRxDrug(rx, drug);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int deleteRx(Prescription rx) { // 删除某一处方
		return doctorMapper.deleteRx(rx);
	}

	@Override
	public int deleteRxDrug(Prescription rx, Drug drug) { // 删除某一处方的某一药品
		return doctorMapper.deleteRxDrug(rx, drug);
	}

	@Override
	public Doctor queryOneDoctor(Doctor doctor) { // 查询某一医生的所有信息
		return doctorMapper.queryOneDoctor(doctor);
	}

	@Override
	public List<Prescription> querySpecificDoctorRxs(Doctor doctor) { // 查询某一医生开出的所有处方
		return doctorMapper.querySpecificDoctorRxs(doctor);
	}

	@Override
	public int changeDpwd(String Dpwd, String Dno) { // 修改登录密码
		int returnValue = 0;

		try {
			returnValue = doctorMapper.changeDpwd(Dpwd, Dno);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}
}
