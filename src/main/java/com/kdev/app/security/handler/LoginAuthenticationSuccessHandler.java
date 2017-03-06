package com.kdev.app.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import com.kdev.app.user.domain.PROVIDER_USER_CP_ID;
import com.kdev.app.user.repositroy.RestrictionRepository;
import com.kdev.app.user.social.domain.SocialUserDetails;

/**
 * @package		: com.kdev.app
 * @filename	: LoginAuthenticationSuccessHandler.java
 * @author		: K
 * @date 		: 2016. 11. 30.
 * @description	: 스프링 시큐리티 로그인 성공시 호출
 */
public class LoginAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	@Autowired
	private RestrictionRepository restrictionRepository;
	
	private static final Logger logger = LoggerFactory.getLogger(LoginAuthenticationSuccessHandler.class);
	public LoginAuthenticationSuccessHandler(String defaultTargetUrl) {
        setDefaultTargetUrl(defaultTargetUrl);
    }
	/**
	 * sendRedirect 이후 return 하지 않을 경우 아래 오류 발생함
	 * Cannot call sendRedirect() after the response has been committed
	 */

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, 
    	Authentication authentication) throws ServletException, IOException {
    	
    	//제재여부 확인
    	SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
    	
    	PROVIDER_USER_CP_ID PROVIDER_USER_CP_ID = new PROVIDER_USER_CP_ID();
		PROVIDER_USER_CP_ID.setUserid(userDetails.getId());
		PROVIDER_USER_CP_ID.setProvider(userDetails.getSocialSignInProvider());
		
		try{
			/**
			 * ==============================================
			 *	로그인한 사용자가 제제되었는지를 확인합니다.
			 *	제제되었을 경우 보여줄 페이지로 리다이렉트합니다.
			 * ==============================================
			 */
			if(restrictionRepository.findOne(PROVIDER_USER_CP_ID) != null){
				SecurityContextHolder.getContext().setAuthentication(null);
				response.sendRedirect("/user/restriction/"+userDetails.getId());
				return;
			}
		}catch(NullPointerException e){
			// 존재하지 않을 경우에는 NullPointerException이 발생한다.
			// 아무것도 하지 않고 넘어가야 로그인 되어집니다.
		}
    	
		/**
		 * ==============================================
		 *	로그인을 시도했을때 이전에 보던 페이지로 리다이렉트 합니다.
		 *	security.controller.LoginController
		 * ==============================================
		 */
    	String redirect = (String)(request.getSession().getAttribute("redirectUrl"));
    	if(redirect != null){
    		request.getSession().removeAttribute("redirectUrl");
    		response.sendRedirect(redirect);
    		return;
    	}
        super.onAuthenticationSuccess(request, response, authentication);
    }
}