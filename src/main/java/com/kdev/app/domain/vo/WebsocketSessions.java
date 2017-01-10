package com.kdev.app.domain.vo;

import java.security.Principal;
import java.util.HashSet;
import java.util.Set;

import lombok.Data;

@Data
public class WebsocketSessions {
	public static final Set<WebsocketSessions> sessions = new HashSet<WebsocketSessions>();
	
	private String sessionid;
	private String destination;
	private UserVO user;
}
