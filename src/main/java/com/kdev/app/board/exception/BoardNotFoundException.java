package com.kdev.app.board.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="게시물을 찾을 수 없습니다")
public class BoardNotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;
}
