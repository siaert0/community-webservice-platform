package com.kdev.app.domain.dto;

import java.util.Collection;
import java.util.Date;

import org.hibernate.validator.constraints.NotEmpty;

import com.kdev.app.domain.vo.Comment;
import com.kdev.app.domain.vo.UserVO;

import lombok.Data;

public class BoardDTO {
	@Data
	public static class Create{
		@NotEmpty
		private String title;
		@NotEmpty
		private String category;
		private String description;
		private String tags;
		private UserVO user;
	}
	
	@Data
	public static class Update{
		private int id;
		@NotEmpty
		private String title;
		@NotEmpty
		private String category;
		private String description;
		private String tags;
		private UserVO user;
		private int selected;
		private Date created;
		private Collection<Comment> comments;
	}
}
