package com.kdev.app.intercepter;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.social.connect.ConnectionRepository;

/**
 * @package		: com.kdev.app
 * @filename	: LoginAuthenticationSuccessHandler.java
 * @author		: K
 * @date 		: 2016. 11. 30.
 * @description	: 스프링 시큐리티 로그인 성공시 호출
 */
public class LoginAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginAuthenticationSuccessHandler.class);
	public LoginAuthenticationSuccessHandler(String defaultTargetUrl) {
        setDefaultTargetUrl(defaultTargetUrl);
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, 
    	Authentication authentication) throws ServletException, IOException {
    	    	
    	String redirect = (String)(request.getSession().getAttribute("redirectUrl"));
    	if(redirect != null){
    		request.getSession().removeAttribute("redirectUrl");
    		response.sendRedirect(redirect);
    		return;
    	}
        super.onAuthenticationSuccess(request, response, authentication);
    }
}