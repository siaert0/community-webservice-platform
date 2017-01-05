package com.kdev.app.domain.dto;

import org.hibernate.validator.constraints.NotEmpty;

import com.kdev.app.domain.vo.UserVO;

import lombok.Data;

public class CommentDTO {
	@Data
	public static class Create{
		private String description;
		private String tags;
		private UserVO user;
		@NotEmpty
		private int board;
	}
	
	@Data
	public static class Update{
		private int id;
		private String description;
		private String tags;
		@NotEmpty
		private int board;
		private UserVO user;
	}
}
