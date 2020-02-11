package com.dims.domain;

public class User { // 用户
	public enum Role {
		ADMIN, DOCTOR, NURSE
	};

	Role role; // 角色
	String no; // 编号
	String pwd; // 登陆密码

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	@Override
	public String toString() {
		return "User [role=" + role + ", no=" + no + ", pwd=" + pwd + "]";
	}
}
