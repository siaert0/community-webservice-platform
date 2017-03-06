package com.kdev.app.user.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.FORBIDDEN, reason="동일한 사용자가 아닙니다")
public class UserNotEqualException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
