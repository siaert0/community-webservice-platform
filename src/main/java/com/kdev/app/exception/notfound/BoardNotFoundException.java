package com.kdev.app.exception.notfound;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="Board not founded")
public class BoardNotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
