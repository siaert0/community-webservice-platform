package com.kdev.app.domain.dto;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Email;

import com.kdev.app.enums.SocialProvider;

import lombok.Data;

public class UserDTO {
	@Data
	public static class Create{
		@NotNull
		private String id;
		@Size(min=8)
		private String password;
		@Email
		private String email;
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private SocialProvider socialSignInProvider;
	}
	
	@Data
	public static class Update{
		@NotNull
		private String id;
		private String password;
		@Email
		private String email;
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private SocialProvider socialSignInProvider;
	}
}
