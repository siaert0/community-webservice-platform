package com.kdev.app.security.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

public class LoginController {
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpSession session, HttpServletRequest request, Model model) {
		String referer = request.getHeader("referer");
		String path = "http://"+request.getServerName();
		if(referer != null){
			path = referer.substring(path.length());
		
			/**
			 *  리다이렉트 되면 안되는 경우를 체크
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
