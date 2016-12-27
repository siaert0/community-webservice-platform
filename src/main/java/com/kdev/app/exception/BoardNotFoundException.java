package com.kdev.app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="Resource not found")
public class BoardNotFoundException extends RuntimeException {
	private String message;
	
	public BoardNotFoundException(String message){
		this.message = message;
	}
}
