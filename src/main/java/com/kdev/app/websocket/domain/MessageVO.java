package com.kdev.app.websocket.domain;

import com.kdev.app.user.domain.UserVO;

import lombok.Data;

@Data
public class MessageVO {
	private String message;
	private UserVO user;
}
