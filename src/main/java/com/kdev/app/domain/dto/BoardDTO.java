package com.kdev.app.domain.dto;

import java.util.Collection;
import java.util.Date;

import com.kdev.app.domain.vo.Comment;
import com.kdev.app.domain.vo.UserVO;

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
		private int selected;
		private Date created;
		private Collection<Comment> comments;
	}
	
}
