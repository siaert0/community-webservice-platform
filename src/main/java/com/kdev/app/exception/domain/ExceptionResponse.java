package com.kdev.app.exception.domain;

import lombok.Data;

/**
 * @author KDEV
 * @date 2017. 1. 18.
 * @description 빌더패턴으로 변경
 */
@Data
public class ExceptionResponse {
	private String path;
	private String error;
	private String status;
	private String exception;
	private String timestamp;
	
	public static class Builder {
		private String path;
		private String error;
		private String status;
		private String exception;
		private String timestamp;
		
		public Builder error(String error){
			this.error = error;
			return this;
		}
		
		public Builder path(String path){
			this.path = path;
			return this;
		}
		
		public Builder status(String status){
			this.status = status;
			return this;
		}
		
		public Builder exception(String exception){
			this.exception = exception;
			return this;
		}
		
		public Builder timestamp(String timestamp){
			this.timestamp = timestamp;
			return this;
		}
		
		public ExceptionResponse build(){
			ExceptionResponse er = new ExceptionResponse();
			er.error = this.error;
			er.path = this.path;
			er.status = this.status;
			er.exception = this.exception;
			er.timestamp = this.timestamp;
			return er;
		}
	}
}
