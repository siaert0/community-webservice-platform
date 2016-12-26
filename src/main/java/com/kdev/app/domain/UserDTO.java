package com.kdev.app.domain;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Email;

import lombok.Data;

public class UserDTO {
	@Data
	public static class Create{
		@NotNull
		private String id;
		@Size(min=4)
		private String password;
		@Email
		private String email;
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private String socialSignInProvider;
	}

	@Data
	public static class Transfer{
		private String id;
		private String nickname;
		private String thumbnail;
	}
}
