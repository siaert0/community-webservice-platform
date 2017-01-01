package com.kdev.app.controller;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.config.WebSocketMessageBrokerStats;

import com.kdev.app.domain.dto.UserDTO;
import com.kdev.app.domain.vo.MessageVO;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.service.UserRepositoryService;

@Controller
public class WebsocketController {
	private static final Logger logger = LoggerFactory.getLogger(WebsocketController.class);
	@Autowired
	private WebSocketMessageBrokerStats websocketMessageBrokerStats;
	
	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate; // 서버에서 보낼때 사용
	
	@Autowired
	private UserRepositoryService userRepositroyService;
	
	@Autowired 
	ModelMapper modelMapper;
	
	@MessageMapping("/notify/{boardnum}")
	@SendTo("/board/{boardnum}")
	public MessageVO notify(@DestinationVariable String boardnum, MessageVO message, Authentication authentication){
		logger.info("{}",websocketMessageBrokerStats.getWebSocketSessionStatsInfo());
		if(authentication != null){
			UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
			UserVO userVO = modelMapper.map(userDetails, UserVO.class);
			UserDTO.Transfer user = modelMapper.map(userVO, UserDTO.Transfer.class);
			message.setUser(user);
		}
		
		return message;
	}
}
