package com.kdev.app.user.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_ACCEPTABLE, reason="This email is duplicated")
public class EmailDuplicatedException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
