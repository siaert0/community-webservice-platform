package com.kdev.app.social.controller;

import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.connect.web.ConnectController;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.servlet.view.RedirectView;

/**
 * @package		: com.kdev.app.controller
 * @filename	: SocialConnectController.java
 * @author		: K
 * @date 		: 2016. 12. 11.
 * @description	: 소셜 계정을 연결할 수 있도록 하는 커넥션 컨트롤러
 */
public class SocialConnectController extends ConnectController {
	
	public SocialConnectController(ConnectionFactoryLocator connectionFactoryLocator,
			ConnectionRepository connectionRepository) {
		super(connectionFactoryLocator, connectionRepository);
		// TODO Auto-generated constructor stub
	}
	
	/* @method		: connectedView
	 * @description	: 연결된 소셜계정에 따라 등록페이지를 분기
	 */
	@Override
	protected String connectedView(String providerId) {
		// TODO Auto-generated method stub
		if(providerId.equals("facebook"))
			return "redirect:/signin/facebook";
		else if(providerId.equals("kakao"))
			return "redirect:/signin/kakao";
		return super.connectedView(providerId);
	}
}
