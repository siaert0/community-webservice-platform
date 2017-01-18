package com.kdev.app.user.domain;

import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotBlank;

import com.kdev.app.user.enums.SocialProvider;

import lombok.Data;
/**
 * @author K
 * @NotNull : Null인 경우
 * @NotEmpty : Null이거나 "" 인 경우
 * @NotBlank : Null이거나 "" 또는 " "인 경우
 */
public class UserDTO {
	@Data
	public static class Create{
		@NotBlank
		private String id;
		@Size(min=8)
		private String password;
		@Email
		private String email;
		@NotBlank
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private SocialProvider socialSignInProvider;
	}
	
	@Data
	public static class Update{
		@NotBlank
		private String id;
		@Size(min=8)
		private String password;
		@Email
		private String email;
		@NotBlank
		private String nickname;
		private String thumbnail;
		private String tags;
		private String role;
		private SocialProvider socialSignInProvider;
	}
	
	@Data
	public static class EmailCheck{
		@Email
		private String email;
	}
}
