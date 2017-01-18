package com.kdev.app.exception.domain;

import lombok.Data;

@Data
public class ExceptionResponse {
	private String path;
	private String error;
	private String status;
	private String exception;
	private String timestamp;
}
