package com.kdev.app.intercepter;

import java.util.Iterator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.kdev.app.domain.vo.WebsocketSessions;

@Component
public class SessionDisconnectedEventListener implements ApplicationListener<SessionDisconnectEvent> {

	private static final Logger logger = LoggerFactory.getLogger(SessionDisconnectedEventListener.class);

	@Override
	public synchronized void onApplicationEvent(SessionDisconnectEvent sessionDisconnectEvent) {
		StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(sessionDisconnectEvent.getMessage());
		
		/**
		 *  구독 연결해제되었을 때 처리된다.
		 */
		String sessionid = headerAccessor.getSessionId();
		Iterator<WebsocketSessions> i = WebsocketSessions.sessions.iterator();
		while(i.hasNext()){
			WebsocketSessions session = i.next();
			if(session.getSessionid().equals(sessionid)){
				i.remove();
			}
		}
	}
}