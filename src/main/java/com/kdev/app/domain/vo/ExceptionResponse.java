package com.kdev.app.domain.vo;

import lombok.Data;

@Data
public class ExceptionResponse {
	private String request;
	private String reason;
	private String status;
}
