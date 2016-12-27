package com.kdev.app.domain;

import lombok.Data;

public class CommentDTO {
	@Data
	public static class Create{
		private String description;
		private String tags;
		private UserVO user;
		private int boardid;
	}
	
	@Data
	public static class Update{
		private int id;
		private String description;
		private String tags;
		private int boardid;
		private UserVO user;
	}
}
