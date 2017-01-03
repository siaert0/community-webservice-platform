package com.kdev.app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

import lombok.Data;

@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="사용자가 존재하지 않을 때 발생합니다.")
public class UserNotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	
	private String userid;

	public UserNotFoundException(String message) {
		this.userid = message;
	}

	public String getUserid() {
		return userid;
	}	
}
