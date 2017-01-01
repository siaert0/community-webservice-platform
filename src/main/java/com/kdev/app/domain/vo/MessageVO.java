package com.kdev.app.domain.vo;

import com.kdev.app.domain.dto.UserDTO;
import com.kdev.app.domain.dto.UserDTO.Transfer;

import lombok.Data;

@Data
public class MessageVO {
	private String message;
	private UserDTO.Transfer user;
}
