package com.kdev.app.domain.vo;

import lombok.Data;

@Data
public class MessageVO {
	private String message;
	private UserVO user;
	private int total;
}
