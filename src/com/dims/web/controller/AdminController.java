package com.dims.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dims.domain.Admin;
import com.dims.domain.DestroyedDrug;
import com.dims.domain.Drug;
import com.dims.domain.InventoryDrug;
import com.dims.domain.Supplier;
import com.dims.service.IAdminService;

@Controller
@RequestMapping(value = "/admin")
public class AdminController {
	@Autowired
	private IAdminService adminService;

	@RequestMapping(value = "/index")
	public String index() {
		// 重定向到 WEB-INF/views/admin/welcome.jsp
		return "redirect:/admin/welcome";
	}

	@RequestMapping(value = "/welcome")
	public String welcome(HttpServletRequest req) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		int lowInventoryDrugsNum = adminService.countLowInventoryDrugs();
		int close2ExpiryPDbatchesNum = adminService.countClose2ExpiryPDbatches();
		int inventoryDrugsNum = adminService.countInventoryDrugs();
		int inventoryPDbatchesNum = adminService.countInventoryPDbatches();
		int destroyedPDbatchesNum = adminService.countDestroyedPDbatches();
		int myInventoryPDbatchesNum = adminService
				.countMyInventoryPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));
		int myPDbatchesNum = adminService.countMyPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));
		int myDestroyedPDbatchesNum = adminService
				.countMyDestoryedPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));

		req.getSession().setAttribute("lowInventoryDrugsNum", lowInventoryDrugsNum);
		req.getSession().setAttribute("close2ExpiryPDbatchesNum", close2ExpiryPDbatchesNum);
		req.getSession().setAttribute("inventoryDrugsNum", inventoryDrugsNum);
		req.getSession().setAttribute("inventoryPDbatchesNum", inventoryPDbatchesNum);
		req.getSession().setAttribute("destroyedPDbatchesNum", destroyedPDbatchesNum);
		req.getSession().setAttribute("myInventoryPDbatchesNum", myInventoryPDbatchesNum);
		req.getSession().setAttribute("myPDbatchesNum", myPDbatchesNum);
		req.getSession().setAttribute("myDestroyedPDbatchesNum", myDestroyedPDbatchesNum);

		// 请求映射到 WEB-INF/views/admin/welcome.jsp
		return "admin/welcome";
	}

	@RequestMapping(value = "/query-low-inventory-drug-list")
	public String queryLowInventoryDrugList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Drug> drugs = adminService.queryLowInventoryDrugs();
		model.addAttribute("drugs", drugs);

		// 请求映射到 WEB-INF/views/admin/query-low-inventory-drug-list.jsp
		return "admin/query-low-inventory-drug-list";
	}

	@RequestMapping(value = "/query-close-2-expiry-pdbatch-list")
	public String queryClose2ExpiryPDbatchList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<InventoryDrug> drugs = adminService.queryClose2ExpiryPDbatches();
		model.addAttribute("drugs", drugs);

		// 请求映射到 WEB-INF/views/admin/query-close-2-expiry-pdbatch-list.jsp
		return "admin/query-close-2-expiry-pdbatch-list";
	}

	@RequestMapping(value = "/profile")
	public String profile(HttpServletRequest req) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		// 请求映射到 WEB-INF/views/admin/profile.jsp
		return "admin/profile";
	}

	@RequestMapping(value = "/query-supplier-list")
	public String querySupplierList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Supplier> suppliers = adminService.queryAllSuppliers();
		model.addAttribute("suppliers", suppliers);

		// 请求映射到 WEB-INF/views/admin/query-supplier-list.jsp
		return "admin/query-supplier-list";
	}

	@RequestMapping(value = "/add-supplier-form")
	public String addSupplierForm(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = true; // add-supplier-form
		req.getSession().setAttribute("type", type);

		// 请求映射到 WEB-INF/views/admin/supplier-form.jsp
		return "admin/supplier-form";
	}

	@RequestMapping(value = "/edit-supplier-form")
	public String editSupplierForm(HttpServletRequest req, Supplier supplier, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = false; // edit-supplier-form
		req.getSession().setAttribute("type", type);

		supplier = adminService.queryOneSupplier(supplier);
		model.addAttribute("supplier", supplier);

		// 请求映射到 WEB-INF/views/admin/supplier-form.jsp
		return "admin/supplier-form";
	}

	@RequestMapping(value = "/submit-supplier-form")
	public String submitSupplierForm(HttpServletRequest req, Supplier supplier, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		String echo = null;

		if ((boolean) req.getSession().getAttribute("type") == true) {
			if (adminService.addNewSupplier(supplier) == 1) {
				echo = "添加成功！";
			} else {
				echo = "添加失败！";
			}
		} else {
			if (adminService.editSupplier(supplier) == 1) {
				echo = "修改成功！";
			} else {
				echo = "修改失败！";
			}
		}

		model.addAttribute("echo", echo);

		List<Supplier> suppliers = adminService.queryAllSuppliers();
		model.addAttribute("suppliers", suppliers);

		// 请求映射到 WEB-INF/views/admin/query-supplier-list
		return "admin/query-supplier-list"; // 不要用重定向，重定向会执行 querySupplierList 方法
	}

	@RequestMapping(value = "/query-drug-list")
	public String queryDrugList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Drug> drugs = adminService.queryAllDrugs();

		for (Drug drug : drugs) {
			drug.setInventoryDrugs(adminService.querySpecificInventoryPDbatches(drug));
			drug.setExistClose2ExpiryPDbatch(false);
			for (InventoryDrug pdbatch : drug.getInventoryDrugs()) {
				if (pdbatch.getRdays() <= (drug.getPDlife() / 10)) {
					drug.setExistClose2ExpiryPDbatch(true);
					break;
				}
			}
		}

		model.addAttribute("drugs", drugs);

		// 请求映射到 WEB-INF/views/admin/query-drug-list.jsp
		return "admin/query-drug-list";
	}

	@RequestMapping(value = "/query-pdbatch-list")
	public String queryPDbatchList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Drug> drugs = adminService.queryAllDrugs();

		for (Drug drug : drugs) {
			drug.setInventoryDrugs(adminService.querySpecificInventoryPDbatches(drug));
			drug.setExistClose2ExpiryPDbatch(false);
			for (InventoryDrug pdbatch : drug.getInventoryDrugs()) {
				if (pdbatch.getRdays() <= (drug.getPDlife() / 10)) {
					drug.setExistClose2ExpiryPDbatch(true);
					break;
				}
			}
		}

		model.addAttribute("drugs", drugs);

		// 请求映射到 WEB-INF/views/admin/query-pdbatch-list.jsp
		return "admin/query-pdbatch-list";
	}

	@RequestMapping(value = "/query-destroyed-pdbatch-list")
	public String queryDestroyedDrugList(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<DestroyedDrug> destroyedDrugs = adminService.queryAllDestroyedPDbatches();
		model.addAttribute("destroyedDrugs", destroyedDrugs);

		// 请求映射到 WEB-INF/views/admin/query-destroyed-pdbatch-list.jsp
		return "admin/query-destroyed-pdbatch-list";
	}

	@RequestMapping(value = "/add-storage-form")
	public String addStorageForm(HttpServletRequest req, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = true; // add-storage-form
		req.getSession().setAttribute("type", type);

		List<Drug> drugs = adminService.queryAllDrugs();
		List<Supplier> suppliers = adminService.queryAllSuppliers();
		List<Admin> admins = adminService.queryAllAdmins();

		model.addAttribute("drugs", drugs);
		model.addAttribute("suppliers", suppliers);
		model.addAttribute("admins", admins);

		// 请求映射到 WEB-INF/views/admin/storage-form.jsp
		return "admin/storage-form";
	}

	@RequestMapping(value = "/edit-storage-form")
	public String editStorageForm(HttpServletRequest req, InventoryDrug pdbatch, String tempPDbatch, Model model)
			throws ParseException {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = false; // edit-storage-form
		req.getSession().setAttribute("type", type);

		List<Supplier> suppliers = adminService.queryAllSuppliers();
		List<Admin> admins = adminService.queryAllAdmins();

		model.addAttribute("suppliers", suppliers);
		model.addAttribute("admins", admins);

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日");
		pdbatch.setPDbatch(dateFormat.parse(tempPDbatch));
		pdbatch = adminService.queryOnePDbatch(pdbatch);
		model.addAttribute("pdbatch", pdbatch);

		// 请求映射到 WEB-INF/views/admin/storage-form.jsp
		return "admin/storage-form";
	}

	@RequestMapping(value = "/specific-storage-form")
	public String specificStorageForm(HttpServletRequest req, Drug specificDrug, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		boolean type = true; // add-storage-form
		req.getSession().setAttribute("type", type);

		specificDrug = adminService.queryOneDrug(specificDrug);
		List<Supplier> suppliers = adminService.queryAllSuppliers();
		List<Admin> admins = adminService.queryAllAdmins();

		model.addAttribute("specificDrug", specificDrug);
		model.addAttribute("suppliers", suppliers);
		model.addAttribute("admins", admins);

		// 请求映射到 WEB-INF/views/admin/specific-storage-form.jsp
		return "admin/specific-storage-form";
	}

	@RequestMapping(value = "/submit-storage-form")
	public String submitStorageForm(HttpServletRequest req, InventoryDrug pdbatch, String tempPDbatch, String tempSdate,
			String tempStime, Model model) throws ParseException {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日");
		SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日 HH:mm:ss");

		pdbatch.setPDbatch(dateFormat.parse(tempPDbatch));
		pdbatch.setStime(datetimeFormat.parse(tempSdate + " " + tempStime));

		String echo = null;

		if ((boolean) req.getSession().getAttribute("type") == true) {
			if (adminService.addNewPDbatch(pdbatch) == 1) {
				echo = "添加成功！";
			} else {
				echo = "添加失败！";
			}
		} else {
			if (adminService.editPDbatch(pdbatch) == 1) {
				echo = "修改成功！";
			} else {
				echo = "修改失败！";
			}
		}

		req.getSession().setAttribute("echo", echo);

		int lowInventoryDrugsNum = adminService.countLowInventoryDrugs();
		int inventoryPDbatchesNum = adminService.countInventoryPDbatches();
		int myInventoryPDbatchesNum = adminService
				.countMyInventoryPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));
		int myPDbatchesNum = adminService.countMyPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));

		req.getSession().setAttribute("lowInventoryDrugsNum", lowInventoryDrugsNum);
		req.getSession().setAttribute("inventoryPDbatchesNum", inventoryPDbatchesNum);
		req.getSession().setAttribute("myInventoryPDbatchesNum", myInventoryPDbatchesNum);
		req.getSession().setAttribute("myPDbatchesNum", myPDbatchesNum);

		Drug specificDrug = new Drug();
		specificDrug.setPDno(pdbatch.getPDno());

		specificDrug = adminService.queryOneDrug(specificDrug);
		specificDrug.setAllPDbatches(adminService.querySpecificPDbatches(specificDrug));

		specificDrug.setExistClose2ExpiryPDbatch(false);
		for (InventoryDrug pdbatch1 : adminService.querySpecificInventoryPDbatches(specificDrug)) {
			if (pdbatch1.getRdays() <= (specificDrug.getPDlife() / 10)) {
				specificDrug.setExistClose2ExpiryPDbatch(true);
				break;
			}
		}

		model.addAttribute("specificDrug", specificDrug);

		// 请求映射到 WEB-INF/views/admin/query-specific-drug
		return "admin/query-specific-drug"; // 不要用重定向，重定向会执行 querySpecificDrug 方法
	}

	@RequestMapping(value = "/destroy-form")
	public String destroyForm(HttpServletRequest req, InventoryDrug pdbatch, String tempPDbatch, Model model)
			throws ParseException {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		List<Admin> admins = adminService.queryAllAdmins();
		model.addAttribute("admins", admins);

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日");
		pdbatch.setPDbatch(dateFormat.parse(tempPDbatch));
		pdbatch = adminService.queryOnePDbatch(pdbatch);
		model.addAttribute("pdbatch", pdbatch);

		// 请求映射到 WEB-INF/views/admin/destroy-form.jsp
		return "admin/destroy-form";
	}

	@RequestMapping(value = "/submit-destroy-form")
	public String submitDestroyForm(HttpServletRequest req, DestroyedDrug pdbatch, String tempPDbatch, String tempDdate,
			String tempDtime, Model model) throws ParseException {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日");
		SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy 年 MM 月 dd 日 HH:mm:ss");

		pdbatch.setPDbatch(dateFormat.parse(tempPDbatch));
		pdbatch.setDtime(datetimeFormat.parse(tempDdate + " " + tempDtime));

		String echo = null;

		if (adminService.destroyPDbatch(pdbatch) == 0) {
			echo = "销毁成功！";
		} else {
			echo = "销毁失败！";
		}

		req.getSession().setAttribute("echo", echo);

		int close2ExpiryPDbatchesNum = adminService.countClose2ExpiryPDbatches();
		int inventoryPDbatchesNum = adminService.countInventoryPDbatches();
		int destroyedPDbatchesNum = adminService.countDestroyedPDbatches();
		int myInventoryPDbatchesNum = adminService
				.countMyInventoryPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));
		int myDestroyedPDbatchesNum = adminService
				.countMyDestoryedPDbatches((Admin) req.getSession().getAttribute("currentAdmin"));

		req.getSession().setAttribute("close2ExpiryPDbatchesNum", close2ExpiryPDbatchesNum);
		req.getSession().setAttribute("inventoryPDbatchesNum", inventoryPDbatchesNum);
		req.getSession().setAttribute("destroyedPDbatchesNum", destroyedPDbatchesNum);
		req.getSession().setAttribute("myInventoryPDbatchesNum", myInventoryPDbatchesNum);
		req.getSession().setAttribute("myDestroyedPDbatchesNum", myDestroyedPDbatchesNum);

		Drug specificDrug = new Drug();
		specificDrug.setPDno(pdbatch.getPDno());

		specificDrug = adminService.queryOneDrug(specificDrug);
		specificDrug.setAllPDbatches(adminService.querySpecificPDbatches(specificDrug));

		specificDrug.setExistClose2ExpiryPDbatch(false);
		for (InventoryDrug pdbatch1 : adminService.querySpecificInventoryPDbatches(specificDrug)) {
			if (pdbatch1.getRdays() <= (specificDrug.getPDlife() / 10)) {
				specificDrug.setExistClose2ExpiryPDbatch(true);
				break;
			}
		}

		model.addAttribute("specificDrug", specificDrug);

		// 请求映射到 WEB-INF/views/admin/query-specific-drug
		return "admin/query-specific-drug"; // 不要用重定向，重定向会执行 querySpecificDrug 方法
	}

	@RequestMapping(value = "/query-specific-drug")
	public String querySpecificDrug(HttpServletRequest req, Drug specificDrug, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		specificDrug = adminService.queryOneDrug(specificDrug);
		specificDrug.setAllPDbatches(adminService.querySpecificPDbatches(specificDrug));

		specificDrug.setExistClose2ExpiryPDbatch(false);
		for (InventoryDrug pdbatch1 : adminService.querySpecificInventoryPDbatches(specificDrug)) {
			if (pdbatch1.getRdays() <= (specificDrug.getPDlife() / 10)) {
				specificDrug.setExistClose2ExpiryPDbatch(true);
				break;
			}
		}

		model.addAttribute("specificDrug", specificDrug);

		// 请求映射到 WEB-INF/views/admin/query-specific-drug.jsp
		return "admin/query-specific-drug";
	}

	@RequestMapping(value = "/query-specific-supplier")
	public String querySpecificSupplier(HttpServletRequest req, Supplier specificSupplier, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		specificSupplier = adminService.queryOneSupplier(specificSupplier);
		specificSupplier.setAllPDbatches(adminService.querySpecificSupplierPDbatches(specificSupplier));
		model.addAttribute("specificSupplier", specificSupplier);

		// 请求映射到 WEB-INF/views/admin/query-specific-supplier.jsp
		return "admin/query-specific-supplier";
	}

	@RequestMapping(value = "query-specific-admin")
	public String querySpecificAdmin(HttpServletRequest req, Admin specificAdmin, Model model) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		req.getSession().removeAttribute("echo");

		specificAdmin = adminService.queryOneAdmin(specificAdmin);
		specificAdmin.setAllPDbatches(adminService.querySpecificAdminPDbatches(specificAdmin));
		model.addAttribute("specificAdmin", specificAdmin);

		// 请求映射到 WEB-INF/views/admin/query-specific-admin.jsp
		return "admin/query-specific-admin";
	}

	@RequestMapping(value = "/changeApwd")
	public String changeApwd(HttpServletRequest req, String Apwd1, String Apwd2) {
		if (req.getSession().getAttribute("currentAdmin") == null) {
			// 重定向到 WEB-INF/views/login.jsp，留在登录页面
			return "redirect:/login";
		}

		Admin currentAdmin = (Admin) req.getSession().getAttribute("currentAdmin");

		String echo = null;

		if (Apwd1.equals(Apwd2)) {
			if (adminService.changeApwd(Apwd1, currentAdmin.getAno()) == 1) {
				echo = "修改密码成功！";
			} else {
				echo = "修改密码失败！请重试！";
			}
		} else {
			echo = "两次输入的密码不一致，修改密码失败！";
		}

		req.getSession().setAttribute("echo", echo);

		// 请求映射到 WEB-INF/views/admin/profile.jsp
		return "admin/profile"; // 不要用重定向，重定向会执行 profile 方法
	}
}
