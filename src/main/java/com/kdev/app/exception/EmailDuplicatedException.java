package com.kdev.app.exception;

public class EmailDuplicatedException extends RuntimeException {
	private String email;

	public EmailDuplicatedException(String message) {
		super(message);
		this.email = message;
	}

	public String getEmail() {
		return email;
	}	
}
