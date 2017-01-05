package com.kdev.app.exception.badgateway;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.BAD_REQUEST, reason="Valid is failed")
public class ValidException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	private String valid;

	public ValidException(String valid) {
		this.valid = valid;
	}

	public String getValid() {
		return valid;
	}
}
