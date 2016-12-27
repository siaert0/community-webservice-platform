package com.kdev.app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.BAD_GATEWAY, reason="Resource not created")
public class NotCreatedException extends RuntimeException {
	private String message;
	
	public NotCreatedException(String message){
		this.message = message;
	}
}
