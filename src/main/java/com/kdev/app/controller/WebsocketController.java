package com.kdev.app.controller;

import java.security.Principal;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.kdev.app.domain.dto.UserDTO;
import com.kdev.app.domain.vo.MessageVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.service.UserRepositoryService;

@Controller
public class WebsocketController {
	
	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate; // 서버에서 보낼때 사용
	
	@Autowired
	private UserRepositoryService userRepositroyService;
	
	@Autowired 
	ModelMapper modelMapper;
	
	@MessageMapping("/notify/{boardnum}")
	@SendTo("/board/{boardnum}")
	public MessageVO notify(@DestinationVariable String boardnum, MessageVO message, Principal principal){
		if(principal != null){
			
			UserVO UserVO = userRepositroyService.findUserByEmail(principal.getName());
			UserDTO.Transfer user = modelMapper.map(UserVO, UserDTO.Transfer.class);
			message.setUser(user);
		}
		
		return message;
	}
}
