package com.dims.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dims.domain.Drug;
import com.dims.domain.Nurse;
import com.dims.domain.Prescription;
import com.dims.service.INurseService;

@Controller
@RequestMapping(value = "/nurse")
public class NurseController {
	@Autowired
	private INurseService nurseService;

	@RequestMapping(value = "/index")
	public String index() {
		// 重定向到 WEB-INF/views/nurse/welcome.jsp
		return "redirect:/nurse/welcome";
	}

	@RequestMapping(value = "/welcome")
	public String welcome(HttpServletRequest req) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		int unsolvedRxsNum = nurseService.countUnsolvedRxs();
		int solvedRxsNum = nurseService.countSolvedRxs();
		int mySolvedRxsNum = nurseService.countMySolvedRxs((Nurse) req.getSession().getAttribute("currentNurse"));

		req.getSession().setAttribute("unsolvedRxsNum", unsolvedRxsNum);
		req.getSession().setAttribute("solvedRxsNum", solvedRxsNum);
		req.getSession().setAttribute("mySolvedRxsNum", mySolvedRxsNum);

		// 请求映射到 WEB-INF/views/nurse/welcome.jsp
		return "nurse/welcome";
	}

	@RequestMapping(value = "/profile")
	public String profile(HttpServletRequest req) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		// 请求映射到 WEB-INF/views/nurse/profile.jsp
		return "nurse/profile";
	}

	@RequestMapping(value = "/query-drug-list")
	public String queryDrugList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Drug> drugs = nurseService.queryAllDrugs();
		model.addAttribute("drugs", drugs);

		// 请求映射到 WEB-INF/views/nurse/query-drug-list.jsp
		return "nurse/query-drug-list";
	}

	@RequestMapping(value = "/query-unsolved-rx-list")
	public String queryUnsolvedPrescriptionList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Prescription> rxs = nurseService.queryAllUnsolvedRxs();
		model.addAttribute("rxs", rxs);

		// 请求映射到 WEB-INF/views/nurse/query-unsolved-rx-list.jsp
		return "nurse/query-unsolved-rx-list";
	}

	@RequestMapping(value = "/query-solved-rx-list")
	public String querySolvedPrescriptionList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Prescription> rxs = nurseService.queryAllSolvedRxs();
		model.addAttribute("rxs", rxs);

		// 请求映射到 WEB-INF/views/nurse/query-solved-rx-list.jsp
		return "nurse/query-solved-rx-list";
	}

	@RequestMapping(value = "/query-specific-rx")
	public String querySpecificRx(HttpServletRequest req, Prescription rx, Model model) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		rx = nurseService.queryOneRx(rx);
		rx.setDrugs(nurseService.queryAllContainedDrugs(rx));
		model.addAttribute("rx", rx);

		// 请求映射到 WEB-INF/views/nurse/query-specific-rx.jsp
		return "nurse/query-specific-rx";
	}

	@RequestMapping(value = "/query-specific-nurse")
	public String querySpecificNurse(HttpServletRequest req, Nurse specificNurse, Model model) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		specificNurse = nurseService.queryOneNurse(specificNurse);
		specificNurse.setAllRxs(nurseService.querySpecificNurseRxs(specificNurse));
		model.addAttribute("specificNurse", specificNurse);

		// 请求映射到 WEB-INF/views/nurse/query-specific-nurse.jsp
		return "nurse/query-specific-nurse";
	}

	@RequestMapping(value = "handle-rx-form")
	public String handleRxForm(HttpServletRequest req, Prescription rx, Model model) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Nurse> nurses = nurseService.queryAllNurses();
		rx = nurseService.queryOneRx(rx);
		rx.setDrugs(nurseService.queryAllContainedDrugs(rx));

		model.addAttribute("nurses", nurses);
		model.addAttribute("rx", rx);

		// 请求映射到 WEB-INF/views/nurse/handle-rx-form.jsp
		return "nurse/handle-rx-form";
	}

	@RequestMapping(value = "/submit-handle-rx-form")
	public String submitHandleRxForm(HttpServletRequest req, Prescription rx, String tempHdate, String tempHtime,
			Model model) throws ParseException {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日 HH:mm:ss");
		rx.setHtime(datetimeFormat.parse(tempHdate + " " + tempHtime));

		String echo = null;

		if (nurseService.handleRx(rx) == 0) {
			echo = "处理成功！";
		} else {
			echo = "处理失败！";
		}

		req.getSession().setAttribute("echo", echo);

		rx = nurseService.queryOneRx(rx);
		rx.setDrugs(nurseService.queryAllContainedDrugs(rx));
		model.addAttribute("rx", rx);

		// 请求映射到 WEB-INF/views/nurse/query-specific-rx.jsp
		return "nurse/query-specific-rx"; // 不要用重定向，重定向会执行 querySpecificRx 方法
	}

	@RequestMapping(value = "/changeNpwd")
	public String changeNpwd(HttpServletRequest req, String Npwd1, String Npwd2) {
		if (req.getSession().getAttribute("currentNurse") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		Nurse currentNurse = (Nurse) req.getSession().getAttribute("currentNurse");

		String echo = null;

		if (Npwd1.equals(Npwd2)) {
			if (nurseService.changeNpwd(Npwd1, currentNurse.getNno()) == 1) {
				echo = "修改密码成功！";
			} else {
				echo = "修改密码失败！请重试！";
			}
		} else {
			echo = "两次输入的密码不一致，修改密码失败！";
		}

		req.getSession().setAttribute("echo", echo);

		// 请求映射到 WEB-INF/views/nurse/profile.jsp
		return "nurse/profile"; // 不要用重定向，重定向会执行 profile 方法
	}
}
