package com.dims.service;

import java.util.List;

import com.dims.domain.Drug;
import com.dims.domain.Nurse;
import com.dims.domain.Prescription;
import com.dims.domain.User;

public interface INurseService {
	public Nurse login(User user); // 登录

	public int countUnsolvedRxs(); // 统计未处理处方数目

	public int countSolvedRxs(); // 统计已处理处方数目

	public int countMySolvedRxs(Nurse nurse); // 统计由该名护士处理的处方数目

	public List<Drug> queryAllDrugs(); // 查看药品库存列表

	public List<Prescription> queryAllUnsolvedRxs(); // 查看未处理处方列表

	public List<Prescription> queryAllSolvedRxs(); // 查看已处理处方列表

	public Prescription queryOneRx(Prescription rx); // 查看某一处方的具体明细

	public List<Drug> queryAllContainedDrugs(Prescription rx); // 查看某一处方包含的所有药品

	public List<Nurse> queryAllNurses(); // 查看护士列表

	public Nurse queryOneNurse(Nurse nurse); // 查询某一护士的所有信息

	public List<Prescription> querySpecificNurseRxs(Nurse nurse); // 查询某一护士处理的所有处方

	public int handleRx(Prescription rx); // 处理一个处方

	public int changeNpwd(String Npwd, String Nno); // 修改登录密码
}
