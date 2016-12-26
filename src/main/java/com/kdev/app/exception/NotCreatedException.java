package com.kdev.app.exception;

public class NotCreatedException extends RuntimeException {
	private String message;
	
	public NotCreatedException(String message){
		this.message = message;
	}
}
