package com.kdev.app.user.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_ACCEPTABLE, reason="이메일이 중복될 경우 발생합니다.")
public class EmailDuplicatedException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
