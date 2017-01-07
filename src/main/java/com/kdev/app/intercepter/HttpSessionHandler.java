package com.kdev.app.intercepter;

import java.util.Enumeration;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kdev.app.controller.AdminController;

public class HttpSessionHandler implements HttpSessionListener {
	private static Logger logger = LoggerFactory.getLogger(HttpSessionHandler.class);
	public static final Set<HttpSession> sessions = java.util.Collections.synchronizedSet(new HashSet<HttpSession>());
	
	@Override
	public void sessionCreated(HttpSessionEvent se) {
		// TODO Auto-generated method stub
		sessions.add(se.getSession());
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		// TODO Auto-generated method stub
		sessions.remove(se.getSession());
	}

}
