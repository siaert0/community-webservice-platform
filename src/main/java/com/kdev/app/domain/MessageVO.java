package com.kdev.app.domain;

import lombok.Data;

@Data
public class MessageVO {
	private String message;
	private UserDTO.Transfer user;
}
