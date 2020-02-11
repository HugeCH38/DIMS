package com.dims.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dims.domain.Drug;
import com.dims.domain.Nurse;
import com.dims.domain.Prescription;
import com.dims.domain.User;
import com.dims.mapper.NurseMapper;
import com.dims.service.INurseService;

@Service
public class NurseServiceImpl implements INurseService {
	@Autowired
	NurseMapper nurseMapper;

	@Override
	public Nurse login(User user) { // 登录
		return nurseMapper.login(user);
	}

	@Override
	public int countUnsolvedRxs() { // 统计未处理处方数目
		return nurseMapper.countUnsolvedRxs();
	}

	@Override
	public int countSolvedRxs() { // 统计已处理处方数目
		return nurseMapper.countSolvedRxs();
	}

	@Override
	public int countMySolvedRxs(Nurse nurse) { // 统计由该名护士处理的处方数目
		return nurseMapper.countMySolvedRxs(nurse);
	}

	@Override
	public List<Drug> queryAllDrugs() { // 查看药品库存列表
		return nurseMapper.queryAllDrugs();
	}

	@Override
	public List<Prescription> queryAllUnsolvedRxs() { // 查看未处理处方列表
		return nurseMapper.queryAllUnsolvedRxs();
	}

	@Override
	public List<Prescription> queryAllSolvedRxs() { // 查看已处理处方列表
		return nurseMapper.queryAllSolvedRxs();
	}

	@Override
	public Prescription queryOneRx(Prescription rx) { // 查看某一处方的具体明细
		return nurseMapper.queryOneRx(rx);
	}

	@Override
	public List<Drug> queryAllContainedDrugs(Prescription rx) { // 查看某一处方包含的所有药品
		return nurseMapper.queryAllContainedDrugs(rx);
	}

	@Override
	public List<Nurse> queryAllNurses() { // 查看护士列表
		return nurseMapper.queryAllNurses();
	}

	@Override
	public Nurse queryOneNurse(Nurse nurse) { // 查询某一护士的所有信息
		return nurseMapper.queryOneNurse(nurse);
	}

	@Override
	public List<Prescription> querySpecificNurseRxs(Nurse nurse) { // 查询某一护士处理的所有处方
		return nurseMapper.querySpecificNurseRxs(nurse);
	}

	@Override
	public int handleRx(Prescription rx) { // 处理一个处方
		int returnValue = 0;

		try {
			returnValue = nurseMapper.handleRx(rx);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}

	@Override
	public int changeNpwd(String Npwd, String Nno) { // 修改登录密码
		int returnValue = 0;

		try {
			returnValue = nurseMapper.changeNpwd(Npwd, Nno);
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}

		return returnValue;
	}
}
