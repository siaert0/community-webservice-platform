package com.kdev.app.exception;

public class BoardNotFoundException extends RuntimeException {
	private String message;
	
	public BoardNotFoundException(String message){
		this.message = message;
	}
}
