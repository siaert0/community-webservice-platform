package com.kdev.app.exception.badgateway;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.BAD_GATEWAY, reason="Resource not updated")
public class NotUpdatedException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
