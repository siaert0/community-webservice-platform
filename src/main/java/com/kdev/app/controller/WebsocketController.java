package com.kdev.app.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.socket.config.WebSocketMessageBrokerStats;

import com.kdev.app.domain.vo.Board;
import com.kdev.app.domain.vo.MessageVO;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.domain.vo.WebsocketSessions;
import com.kdev.app.exception.notfound.BoardNotFoundException;

@Controller
public class WebsocketController {
	private static final Logger logger = LoggerFactory.getLogger(WebsocketController.class);
	
	@Autowired 
	ModelMapper modelMapper;
	
	@Autowired
	WebSocketMessageBrokerStats wmbs;
	
	@MessageMapping("/notify/{boardnum}")
	@SendTo("/board/{boardnum}")
	public MessageVO notify(@DestinationVariable String boardnum, MessageVO message, Authentication authentication){
		if(authentication != null){
			UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
			UserVO userVO = modelMapper.map(userDetails, UserVO.class);
			message.setUser(userVO);
			String destination = "/board/"+boardnum;
			List<WebsocketSessions> list = WebsocketSessions.sessions.stream().filter(websocket -> destination.equals(websocket.getDestination()))
			.collect(Collectors.toList());
			message.setTotal(list.size());
		}
		
		return message;
	}
	
	@RequestMapping(value="/subscribe/board/{id}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoardMessageUser(@PathVariable int id){
		
		String destination = "/board/"+id;
		List<WebsocketSessions> list = WebsocketSessions.sessions.stream().filter(websocket -> destination.equals(websocket.getDestination()))
		.collect(Collectors.toList());
		
		return new ResponseEntity<Object>(list, HttpStatus.OK);
	}
}
