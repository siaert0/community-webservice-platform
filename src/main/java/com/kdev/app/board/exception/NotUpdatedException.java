package com.kdev.app.board.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.BAD_GATEWAY, reason="수정할 수 없습니다")
public class NotUpdatedException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
