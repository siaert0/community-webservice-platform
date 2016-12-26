package com.kdev.app.domain;

import java.util.Date;
import java.util.List;
import java.util.Map;

import lombok.Data;

public class BoardDTO {
	@Data
	public static class Create{
		private String title;
		private String category;
		private String description;
		private String tags;
		private UserVO user;
	}
	
	@Data
	public static class Update{
		private int id;
		private String title;
		private String category;
		private String description;
		private String tags;
		private UserVO user;
	}
	
	@Data
	public static class Transfer{
		private int id;
		private String title;
		private String category;
		private String description;
		private Map<String, Object> tags;
		private UserVO user;
		private Date created;
	}
}
