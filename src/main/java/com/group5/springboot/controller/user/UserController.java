package com.group5.springboot.controller.user;

import java.io.File;
import java.io.InputStream;
import java.sql.Blob;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.group5.springboot.model.user.User_Info;
import com.group5.springboot.service.user.IUserService;
import com.group5.springboot.utils.EmailSenderService;
import com.group5.springboot.utils.SystemUtils;
import com.group5.springboot.validate.UserValidator;

@Controller
@SessionAttributes(names = {"loginBean","adminBean"})
public class UserController {
	@Autowired
	IUserService iUserService;
	@Autowired
	User_Info user_info;
	@Autowired
	UserValidator userValidator;
	@Autowired
	ServletContext context;
	@Autowired
	EmailSenderService emailService;

	// 到會員的index
	@GetMapping(path = "/gotoUserIndex.controller")
	public String gotoUserIndex() {
		return "user/userIndex";
	}
	
	//到登入頁面
	@GetMapping(path = "/gotologin.controller")
	public String gotoLoginPage(Model model) {
		String returnPage = "";
		boolean loginResult = checkIfLogin(model);
		if (loginResult) {
			returnPage = "index";
		}else {
			returnPage = "user/login";
		}
		return returnPage;
	}
	
	
	//到註冊頁面
	@GetMapping(path = "/gotosignup.controller")
	public String gotoSignupPage() {
		return "user/signup";
	}
		
	//到刪除會員的頁面
	@GetMapping(path = "/gotoDeleteUser.controller/{u_id}")
	public String gotoDeleteUser(@PathVariable String u_id, Model model) {
		model.addAttribute("u_id", u_id);
		return "user/deleteUser";
	}
	
	//到修改會員資料頁面
	@GetMapping(path = "/gotoUpdateUserinfo.controller")
	public String gotoUpdateUserinfo(Model model) {
		String returnPage = "";
		boolean loginResult = checkIfLogin(model);
		if (loginResult) {
			returnPage = "user/updateUser";
		}else {
			returnPage = "user/login";
		}
		return returnPage;
	}
	
	
	//到修改會員密碼頁面
	@GetMapping(path = "/gotoChangePassword.controller")
	public String gotoChangePassword(Model model) {
		String returnPage = "";
		boolean loginResult = checkIfLogin(model);
		if (loginResult) {
			returnPage = "user/changePassword";
		}else {
			returnPage = "user/login";
		}
		return returnPage;
	}
	
	
	//讀取單筆會員資料(全部會員資料到刪除單筆資料)
	@GetMapping("/showSingleUser.controller/{u_id}")
	public @ResponseBody User_Info showSingleUser(@PathVariable String u_id) {
		User_Info user = iUserService.getSingleUser(u_id);
		return user;
	}
	
	
	//登入
	@PostMapping(path = "/login.controller", produces = {"application/json"})
	@ResponseBody
	public Map<String, Object> login(@RequestBody User_Info user_Info, Model model){
		Map<String, Object> map = new HashMap<>();
		user_info = null;
		try {
			user_info = iUserService.login(user_Info);
			if(user_info != null && user_info.getU_id().length()>0) {
				map.put("success", "登入成功");
//				map.put("u_id", user_info.getU_id());
				map.put("loginBean", user_info);
				
				//登入成功:把使用者資訊加到sessionScope上
				model.addAttribute("loginBean", user_info);
			} else if(user_info == null) {
				map.put("fail", "帳號或密碼錯誤，請再試一次...");
			}
		} catch (Exception e) {
			System.out.println("********************************");
			System.out.println("有exception，在\'登入controller\'");
			System.out.println("********************************");
			map.put("fail", e.getMessage());
		}
		return map;
	}
	
	//檢查帳號是否可用
	@PostMapping(path = "/checkUserId", produces = {"application/json"})
	@ResponseBody
	public Map<String, String> checkUserId(@RequestParam String u_id){
		Map<String, String> map = new HashMap<>();
		String user_id = iUserService.checkUserId(u_id);
		map.put("u_id", user_id);
		return map;
	}
	
	//會員註冊
	@PostMapping(path = "/userSignup", produces = {"application/json"})
	@ResponseBody
	public Map<String, String> signup(@RequestBody User_Info user_Info){
		Map<String, String> map = new HashMap<>();
		// 檢查信箱格式
		try {
			if(!(user_Info.getU_email().trim().contains("@"))) {
				map.put("formatError", "信箱格式錯誤!");
				return map;
			}
		} catch (Exception e) {
			map.put("fail", e.getMessage());
		}
		
		
		int n = 0;
		try {
			n = iUserService.saveUser(user_Info);
			if(n == 1) {
				map.put("success", "註冊成功");
				//寄成功註冊的信件
				String body = "用戶: " + user_Info.getU_id() + " 您好，歡迎註冊成為Studie Hub的會員，祝您使用愉快!";
				emailService.sendSimpleEmail(user_Info.getU_email(),
											 body,
											 "Studie Hub 會員註冊成功通知");
			}else if(n == -1) {
				map.put("fail", "帳號重複");
			}
		} catch (Exception e) {
			System.out.println("********************************");
			System.out.println("有exception，在\'會員註冊controller\'");
			System.out.println("********************************");
			map.put("fail", e.getMessage());
		}
		return map;
	}
	
	
	//刪除會員資料
	@DeleteMapping("/user.controller/{u_id}")
	@ResponseBody
	public Map<String, String> deleteUser(@PathVariable(required = true) String u_id){
		Map<String, String> map = new HashMap<>();
		try {
			iUserService.deleteUserById(u_id);
			map.put("success", "刪除成功");
		} catch (Exception e) {
			map.put("fail", "刪除失敗，請再試一次...");
			e.printStackTrace();
		}
		return map;
	}
	
	
	//修改密碼
	@PostMapping("/changePassword.controller")
	public String changePassword(@ModelAttribute("userBean") User_Info user_Info,
			RedirectAttributes ra,
			@RequestParam String u_psw, @RequestParam String cfm_psw,
			Model model, SessionStatus status) {
		
		System.out.println("u_psw="+u_psw+", cfm_psw="+cfm_psw);
		if(!(u_psw.equals(cfm_psw))) {
			ra.addFlashAttribute("errorMessageOfChangingPassword", "兩次密碼不同");
			return "redirect:/gotoChangePassword.controller";
		}
		
		iUserService.updateUser(user_Info);
		updateLoginBean(model, status);	//更新sessionAttribute裡的bean資料
		ra.addFlashAttribute("successMessageOfChangingPassword", "修改成功");
		return "redirect:/";
	}
	

	
	//修改會員資料
	@PostMapping("/updateUserinfo.controller")
	public String updateUser(@ModelAttribute("userBean") User_Info user_Info,
			BindingResult bindingResult,
			RedirectAttributes ra,
			Model model, SessionStatus status) {
		
		userValidator.validate(user_Info, bindingResult);
		if(bindingResult.hasErrors()) {
			return "user/updateUser";
		}
		
		Blob blob = null;
		String mimeType = "";
		String ogfName = "";
		MultipartFile uploadImage = user_Info.getUploadImage();
		if(uploadImage != null && uploadImage.getSize() > 0) {
			try {
				InputStream is = uploadImage.getInputStream();
				ogfName = uploadImage.getOriginalFilename();
				blob = SystemUtils.inputStreamToBlob(is);
				mimeType = context.getMimeType(ogfName);
				user_Info.setU_img(blob);
				user_Info.setMimeType(mimeType);
				//將上傳的檔案移到指定的資料夾
				String ext = SystemUtils.getExtFilename(ogfName);
				try {
					File imageFolder = new File(SystemUtils.PLACE_IMAGE_FOLDER);
					if (!imageFolder.exists())
						imageFolder.mkdirs();
					File file = new File(imageFolder, "MemberImage_" + user_Info.getU_id() + ext);
					uploadImage.transferTo(file);
				} catch (Exception e) {
					e.printStackTrace();
					throw new RuntimeException("檔案上傳發生異常: " + e.getMessage());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		iUserService.updateUser(user_Info);
		updateLoginBean(model, status);	//更新sessionAttribute裡的bean資料
		ra.addFlashAttribute("successMessage", "修改成功");	//暫時沒做秀出成功訊息
		return "redirect:/gotoUpdateUserinfo.controller";
	}
	
	
	
	//查看是否登入
	public boolean checkIfLogin(Model model) {
		boolean result = false;
		try {
			User_Info userBean = (User_Info)model.getAttribute("loginBean");
			if(userBean!=null && userBean.getU_id()!=null && userBean.getU_id().length()>0) {
				System.out.println("在\'確認是否登入\'這邊的loginBean name: " + userBean.getU_firstname() + userBean.getU_lastname());
				result = true;
			}else {
				result = false;
			}
		} catch (Exception e) {
			result = false;
			System.out.println("有問題喔，在\'確認是否登入\'這邊......");
		}
		return result;
	}
	
	
	//更新sessionAttribute裡的bean資料
	public void updateLoginBean(Model model, SessionStatus status) {
		User_Info loginBean = (User_Info)model.getAttribute("loginBean");
		System.out.println("oldBean id:" + loginBean.getU_id() + ", old psw:" + loginBean.getU_psw() + ", old lastname:" + loginBean.getU_lastname());
		User_Info updateBean = iUserService.getSingleUser(loginBean.getU_id());
		System.out.println("updatedBean id:" + updateBean.getU_id() + ", update psw:" + updateBean.getU_psw() + ", update lastname" + updateBean.getU_lastname());
		model.addAttribute("loginBean", updateBean);
	}
	
	
	
	//0624新增ModelAttribute
	@ModelAttribute("userBean")
//	public User_Info getLoginUserInfos(User_Info userBean, Model model){
	public User_Info getLoginUserInfos(Model model){
		User_Info loginBean = (User_Info)model.getAttribute("loginBean");
		System.out.println("******************************************");
		User_Info userInfo = null;
		try {
			userInfo = iUserService.getSingleUser(loginBean.getU_id());
			System.out.println("******************************************");
			System.out.println("in getLoginUserIndos, id= " + userInfo.getU_id());
			System.out.println("******************************************");
		} catch (Exception e) {
			userInfo = new User_Info();
			System.out.println("no login Bean in getLoginUserInfos().......");
		}
		return userInfo;
	}
	
	//GENDER LIST
	@ModelAttribute("genderList")
    public Map<String, String>  getGenderList(){
		Map<String, String> map = new LinkedHashMap<>();
		map.put("男", "男");
		map.put("女", "女");
		return map;
    }
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
