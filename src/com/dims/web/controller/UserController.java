package com.dims.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dims.domain.Admin;
import com.dims.domain.Doctor;
import com.dims.domain.Nurse;
import com.dims.domain.User;
import com.dims.service.IAdminService;
import com.dims.service.IDoctorService;
import com.dims.service.INurseService;

@Controller
@RequestMapping(value = "/")
public class UserController {
	@Autowired
	private IAdminService adminService;

	@Autowired
	private IDoctorService doctorService;

	@Autowired
	private INurseService nurseService;

	@RequestMapping(value = "index")
	public String index() {
		// 重定向到 WEB-INF/views/login.jsp
		return "redirect:/login";
	}

	@RequestMapping(value = "login")
	public String login(HttpServletRequest req) {
		req.getSession().removeAttribute("echo");

		// 请求映射到 WEB-INF/views/login.jsp
		return "/login";
	}

	@RequestMapping(value = "submitLogin")
	public String submitLogin(HttpServletRequest req, User user) {
		String echo;

		switch (user.getRole()) {
		case ADMIN:
			Admin currentAdmin = adminService.login(user);
			if (currentAdmin != null) { // 登录成功
				req.getSession().setAttribute("currentAdmin", currentAdmin);

				// 重定向到 WEB-INF/views/admin/index.jsp
				return "redirect:/admin/index";
			} else {
				echo = "登陆失败！";
				req.getSession().setAttribute("echo", echo);

				// 请求映射到 WEB-INF/views/login.jsp，留在登录页面
				return "/login"; // 不要用重定向，重定向会执行 login 方法
			}
		case DOCTOR:
			Doctor currentDoctor = doctorService.login(user);
			if (currentDoctor != null) { // 登录成功
				req.getSession().setAttribute("currentDoctor", currentDoctor);

				// 重定向到 WEB-INF/views/doctor/index.jsp
				return "redirect:/doctor/index";
			} else {
				echo = "登陆失败！";
				req.getSession().setAttribute("echo", echo);

				// 请求映射到 WEB-INF/views/login.jsp，留在登录页面
				return "/login"; // 不要用重定向，重定向会执行 login 方法
			}
		case NURSE:
			Nurse currentNurse = nurseService.login(user);
			if (currentNurse != null) { // 登录成功
				req.getSession().setAttribute("currentNurse", currentNurse);

				// 重定向到 WEB-INF/views/nurse/index.jsp
				return "redirect:/nurse/index";
			} else {
				echo = "登陆失败！";
				req.getSession().setAttribute("echo", echo);

				// 请求映射到 WEB-INF/views/login.jsp，留在登录页面
				return "/login"; // 不要用重定向，重定向会执行 login 方法
			}
		default:
			echo = "登陆失败！";
			req.getSession().setAttribute("echo", echo);

			// 请求映射到 WEB-INF/views/login.jsp，留在登录页面
			return "/login"; // 不要用重定向，重定向会执行 login 方法
		}
	}

	@RequestMapping(value = "logout")
	public String logout(HttpServletRequest req) {
		req.getSession().invalidate();

		// 重定向到 WEB-INF/views/login.jsp
		return "redirect:/login";
	}

	@RequestMapping(value = "admin")
	public String admin() {
		// 重定向到 WEB-INF/views/admin/index.jsp
		return "redirect:/admin/index";
	}

	@RequestMapping(value = "doctor")
	public String doctor() {
		// 重定向到 WEB-INF/views/doctor/index.jsp
		return "redirect:/doctor/index";
	}

	@RequestMapping(value = "nurse")
	public String nurse() {
		// 重定向到 WEB-INF/views/nurse/index.jsp
		return "redirect:/nurse/index";
	}
}
