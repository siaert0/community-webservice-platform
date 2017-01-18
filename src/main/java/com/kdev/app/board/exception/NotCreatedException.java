package com.kdev.app.board.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.BAD_GATEWAY, reason="Resource not created")
public class NotCreatedException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
