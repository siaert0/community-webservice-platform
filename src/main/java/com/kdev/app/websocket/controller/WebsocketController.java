package com.kdev.app.websocket.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.socket.config.WebSocketMessageBrokerStats;

import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.social.domain.SocialUserDetails;
import com.kdev.app.websocket.domain.Message;

/**
 * <pre>
 * com.kdev.app.websocket.controller
 * WebsocketController.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2017. 3. 6.
 * @updated 2017. 3. 6.
 * @history -
 * ==============================================
 *
 * ==============================================
 */
@Controller
public class WebsocketController {
	private static final Logger logger = LoggerFactory.getLogger(WebsocketController.class);
	
	ModelMapper modelMapper;
	
	WebSocketMessageBrokerStats wmbs;
	
	public WebsocketController(ModelMapper modelMapper, WebSocketMessageBrokerStats wmbs) {
		this.modelMapper = modelMapper;
		this.wmbs = wmbs;
	}

	@SendTo("/notification/{userid}")
	public Message notify(@DestinationVariable String userid, Message message, Authentication authentication){
		if(authentication != null){
			SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
			UserVO userVO = modelMapper.map(userDetails, UserVO.class);
			message.setUser(userVO);
		}
		return message;
	}
}