package com.kdev.app.user.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

import lombok.Data;

@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="사용자를 찾을 수 없습니다")
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
