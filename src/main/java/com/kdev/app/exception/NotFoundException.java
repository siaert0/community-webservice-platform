package com.kdev.app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="Resource not found")
public class NotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	private String message;
	
	public NotFoundException(String message){
		this.message = message;
	}

	public String getMessage() {
		return message;
	}
}
