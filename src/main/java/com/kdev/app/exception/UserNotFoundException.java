package com.kdev.app.exception;

public class UserNotFoundException extends RuntimeException {
	private String userid;

	public UserNotFoundException(String message) {
		this.userid = message;
	}

	public String getUserid() {
		return userid;
	}	
}
