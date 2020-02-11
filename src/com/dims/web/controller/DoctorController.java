package com.dims.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dims.domain.Doctor;
import com.dims.domain.Drug;
import com.dims.domain.Prescription;
import com.dims.service.IDoctorService;

@Controller
@RequestMapping(value = "/doctor")
public class DoctorController {
	@Autowired
	private IDoctorService doctorService;

	@RequestMapping(value = "/index")
	public String index() {
		// 重定向到 WEB-INF/views/doctor/welcome.jsp
		return "redirect:/doctor/welcome";
	}

	@RequestMapping(value = "/welcome")
	public String welcome(HttpServletRequest req) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		int unsolvedRxsNum = doctorService.countUnsolvedRxs();
		int solvedRxsNum = doctorService.countSolvedRxs();
		int myPrescribeRxsNum = doctorService
				.countMyPrescribeRxs((Doctor) req.getSession().getAttribute("currentDoctor"));

		req.getSession().setAttribute("unsolvedRxsNum", unsolvedRxsNum);
		req.getSession().setAttribute("solvedRxsNum", solvedRxsNum);
		req.getSession().setAttribute("myPrescribeRxsNum", myPrescribeRxsNum);

		// 请求映射到 WEB-INF/views/doctor/welcome.jsp
		return "doctor/welcome";
	}

	@RequestMapping(value = "/profile")
	public String profile(HttpServletRequest req) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		// 请求映射到 WEB-INF/views/doctor/profile.jsp
		return "doctor/profile";
	}

	@RequestMapping(value = "/query-drug-list")
	public String queryDrugList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Drug> drugs = doctorService.queryAllDrugs();
		model.addAttribute("drugs", drugs);

		// 请求映射到 WEB-INF/views/doctor/query-drug-list.jsp
		return "doctor/query-drug-list";
	}

	@RequestMapping(value = "/add-rx-form")
	public String addRxForm(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = true; // add-rx-form
		req.getSession().setAttribute("type", type);

		List<Drug> drugs = doctorService.queryAllDrugs();
		List<Doctor> doctors = doctorService.queryAllDoctors();
		model.addAttribute("drugs", drugs);
		model.addAttribute("doctors", doctors);

		// 请求映射到 WEB-INF/views/doctor/rx-form.jsp
		return "doctor/rx-form";
	}

	@RequestMapping(value = "/edit-rx-form")
	public String editRxForm(HttpServletRequest req, Prescription rx, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = false; // edit-rx-form
		req.getSession().setAttribute("type", type);

		rx = doctorService.queryOneRx(rx);
		rx.setDrugs(doctorService.queryAllContainedDrugs(rx));
		List<Drug> drugs = doctorService.queryAllDrugs();
		List<Doctor> doctors = doctorService.queryAllDoctors();

		model.addAttribute("rx", rx);
		model.addAttribute("drugs", drugs);
		model.addAttribute("doctors", doctors);

		// 请求映射到 WEB-INF/views/doctor/rx-form.jsp
		return "doctor/rx-form";
	}

	@RequestMapping(value = "/submit-rx-form")
	public String submitRxForm(HttpServletRequest req, Prescription rx, String tempPdate, String tempPtime, Model model)
			throws ParseException {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日 HH:mm:ss");
		rx.setPtime(datetimeFormat.parse(tempPdate + " " + tempPtime));

		String echo = null;

		if ((boolean) req.getSession().getAttribute("type") == true) {
			if (doctorService.addNewRx(rx) == 1) {
				echo = "添加成功！";
			} else {
				echo = "添加失败！";
			}
		} else {
			if (doctorService.editRx(rx) == 1) {
				echo = "修改成功！";
			} else {
				echo = "修改失败！";
			}
		}

		req.getSession().setAttribute("echo", echo);

		boolean type = false; // edit-rx-form
		req.getSession().setAttribute("type", type);

		rx = doctorService.queryOneRx(rx);
		rx.setDrugs(doctorService.queryAllContainedDrugs(rx));
		List<Drug> drugs = doctorService.queryAllDrugs();
		List<Doctor> doctors = doctorService.queryAllDoctors();

		model.addAttribute("rx", rx);
		model.addAttribute("drugs", drugs);
		model.addAttribute("doctors", doctors);

		// 请求映射到 WEB-INF/views/doctor/rx-form.jsp
		return "doctor/rx-form"; // 不要用重定向，重定向会执行 rxForm 方法 (没有这个方法)
	}

	@RequestMapping(value = "/submit-rx-drug-form")
	public String submitRxDrugForm(HttpServletRequest req, Prescription rx, Drug drug, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		String echo = null;

		if (drug.getPDnum() <= doctorService.queryOneDrugNum(drug)) {
			if (doctorService.existRxDrug(rx, drug)) {
				if (doctorService.editRxDrug(rx, drug) == 1) {
					echo = "该药品已存在！药品数量修改成功！";
				} else {
					echo = "该药品已存在！药品数量修改失败！";
				}
			} else {
				if (doctorService.addNewRxDrug(rx, drug) == 1) {
					echo = "添加成功！";
				} else {
					echo = "添加失败！";
				}
			}
		} else {
			echo = "该药品的库存数量不足！";
		}

		req.getSession().setAttribute("echo", echo);

		boolean type = false; // edit-rx-form
		req.getSession().setAttribute("type", type);

		rx = doctorService.queryOneRx(rx);
		rx.setDrugs(doctorService.queryAllContainedDrugs(rx));
		List<Drug> drugs = doctorService.queryAllDrugs();
		List<Doctor> doctors = doctorService.queryAllDoctors();

		model.addAttribute("rx", rx);
		model.addAttribute("drugs", drugs);
		model.addAttribute("doctors", doctors);

		// 请求映射到 WEB-INF/views/doctor/rx-form.jsp
		return "doctor/rx-form"; // 不要用重定向，重定向会执行 rxForm 方法 (没有这个方法)
	}

	@RequestMapping(value = "/query-solved-rx-list")
	public String querySolvedRxList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Prescription> rxs = doctorService.queryAllSolvedRxs();
		model.addAttribute("rxs", rxs);

		// 请求映射到 WEB-INF/views/doctor/query-solved-rx-list.jsp
		return "doctor/query-solved-rx-list";
	}

	@RequestMapping(value = "/query-unsolved-rx-list")
	public String queryUnsolvedRxList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Prescription> rxs = doctorService.queryAllUnsolvedRxs();
		model.addAttribute("rxs", rxs);

		// 请求映射到 WEB-INF/views/doctor/query-unsolved-rx-list.jsp
		return "doctor/query-unsolved-rx-list";
	}

	@RequestMapping(value = "/query-specific-rx")
	public String querySpecificRx(HttpServletRequest req, Prescription rx, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		rx = doctorService.queryOneRx(rx);
		rx.setDrugs(doctorService.queryAllContainedDrugs(rx));
		model.addAttribute("rx", rx);

		// 请求映射到 WEB-INF/views/doctor/query-specific-rx.jsp
		return "doctor/query-specific-rx";
	}

	@RequestMapping(value = "/delete-rx")
	public String deleteRx(HttpServletRequest req, Prescription rx, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		String echo = null;

		if (doctorService.deleteRx(rx) == 1) {
			echo = "删除成功！";
		} else {
			echo = "删除失败！";
		}

		req.getSession().setAttribute("echo", echo);

		List<Prescription> rxs = doctorService.queryAllUnsolvedRxs();
		model.addAttribute("rxs", rxs);

		// 请求映射到 WEB-INF/views/doctor/query-unsolved-rx-list.jsp
		return "doctor/query-unsolved-rx-list"; // 不要用重定向，重定向会执行 queryUnsolvedRxList 方法
	}

	@RequestMapping(value = "/delete-rx-drug")
	public String deleteRxDrug(HttpServletRequest req, Prescription rx, Drug drug, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		String echo = null;

		if (doctorService.deleteRxDrug(rx, drug) == 1) {
			echo = "删除成功！";
		} else {
			echo = "删除失败！";
		}

		req.getSession().setAttribute("echo", echo);

		boolean type = false; // edit-rx-form
		req.getSession().setAttribute("type", type);

		rx = doctorService.queryOneRx(rx);
		rx.setDrugs(doctorService.queryAllContainedDrugs(rx));
		List<Drug> drugs = doctorService.queryAllDrugs();
		List<Doctor> doctors = doctorService.queryAllDoctors();

		model.addAttribute("rx", rx);
		model.addAttribute("drugs", drugs);
		model.addAttribute("doctors", doctors);

		// 请求映射到 WEB-INF/views/doctor/rx-form.jsp
		return "doctor/rx-form"; // 不要用重定向，重定向会执行 rxForm 方法 (没有这个方法)
	}

	@RequestMapping(value = "/query-specific-doctor")
	public String querySpecificDoctor(HttpServletRequest req, Doctor specificDoctor, Model model) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		specificDoctor = doctorService.queryOneDoctor(specificDoctor);
		specificDoctor.setAllRxs(doctorService.querySpecificDoctorRxs(specificDoctor));
		model.addAttribute("specificDoctor", specificDoctor);

		// 请求映射到 WEB-INF/views/doctor/query-specific-doctor.jsp
		return "doctor/query-specific-doctor";
	}

	@RequestMapping(value = "/changeDpwd")
	public String changeDpwd(HttpServletRequest req, String Dpwd1, String Dpwd2) {
		if (req.getSession().getAttribute("currentDoctor") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		Doctor currentDoctor = (Doctor) req.getSession().getAttribute("currentDoctor");

		String echo = null;

		if (Dpwd1.equals(Dpwd2)) {
			if (doctorService.changeDpwd(Dpwd1, currentDoctor.getDno()) == 1) {
				echo = "修改密码成功！";
			} else {
				echo = "修改密码失败！请重试！";
			}
		} else {
			echo = "两次输入的密码不一致，修改密码失败！";
		}

		req.getSession().setAttribute("echo", echo);

		// 请求映射到 WEB-INF/views/doctor/profile.jsp
		return "doctor/profile"; // 不要用重定向，重定向会执行 profile 方法
	}
}
