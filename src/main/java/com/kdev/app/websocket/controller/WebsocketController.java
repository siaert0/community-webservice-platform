package com.kdev.app.websocket.controller;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.social.domain.SocialUserDetails;
import com.kdev.app.websocket.domain.MessageVO;

@Controller
public class WebsocketController {
	private static final Logger logger = LoggerFactory.getLogger(WebsocketController.class);
	
	@Autowired 
	ModelMapper modelMapper;
	
	@MessageMapping("/notify")
	@SendTo("/board")
	public MessageVO notify(MessageVO message, Authentication authentication){
		if(authentication != null){
			SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
			UserVO userVO = modelMapper.map(userDetails, UserVO.class);
			message.setUser(userVO);
		}
		return message;
	}
}
