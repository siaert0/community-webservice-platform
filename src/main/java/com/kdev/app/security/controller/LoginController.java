package com.kdev.app.security.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * <pre>
 * com.kdev.app.security.controller
 * LoginController.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2017. 12. 20.
 * @updated 2017. 3. 6.
 * @history -
 * ==============================================
 *	2017. 3. 6. 클래스 설명 주석 추가
 * ==============================================
 */
@Controller
public class LoginController {
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpSession session, HttpServletRequest request, Model model) {
		/**
		 * ==============================================
		 *	요청 헤더에서 referer를 체크해서 이전에 보던 페이지 정보를 가져옵니다.
		 * ==============================================
		 */
		String referer = request.getHeader("referer");
		String path = "http://"+request.getServerName();
		if(referer != null){
			path = referer.substring(path.length());
			/**
			 * ==============================================
			 *	이전에 보던 페이지가 리다이렉트 되면 안되는 경우를 체크합니다.
			 * ==============================================
			 */
			if(!(path.equals("/connect/kakao") 
					|| path.equals("/connect/facebook") 
					|| path.equals("/user") 
					|| path.equals("/signin/facebook") 
					|| path.equals("/signin/kakao")
					|| path.equals("/login"))){
				session.setAttribute("redirectUrl", referer);
			}
		}
		return "login";
	}
}
