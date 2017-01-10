package com.kdev.app.intercepter;

import java.security.Principal;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;

import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.domain.vo.WebsocketSessions;
import com.kdev.app.service.UserRepositoryService;

@Component
public class StompSubscribeEventListener implements ApplicationListener<SessionSubscribeEvent> {

	private static final Logger logger = LoggerFactory.getLogger(StompSubscribeEventListener.class);
	
	@Override
	public synchronized void onApplicationEvent(SessionSubscribeEvent sessionSubscribeEvent) {
		StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(sessionSubscribeEvent.getMessage());

		/**
		 *  구독 연결되었을 때 처리된다.
		 *  계정정보가 있을 경우에만 구독자로 처리한다.
		 */
		
		Principal principal = headerAccessor.getUser();
		if(principal != null){
			WebsocketSessions ws = new WebsocketSessions();
			ws.setSessionid(headerAccessor.getSessionId());
			ws.setDestination(headerAccessor.getDestination());
			WebsocketSessions.sessions.add(ws);
		}
	}
}