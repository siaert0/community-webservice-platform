package com.kdev.app.exception;

import lombok.Data;

@Data
public class ExceptionResponse {
	private String request;
	private String response;
	private String httpStatus;
}
