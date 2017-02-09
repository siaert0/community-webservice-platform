package com.kdev.app.user.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotBlank;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.kdev.app.user.enums.Role;
import com.kdev.app.user.enums.SocialProvider;

import lombok.Data;

@Entity
@Table(name = "USERS")
@Data
public class UserVO {
	@Id
	@Column(name = "USER_ID", length=155)
	private String id;
	
	@Column(name = "USER_EMAIL")
	private String email;
	
	@Column(name = "USER_NICKNAME")
	private String nickname;
	
	@JsonIgnore // JSON으로 응답시에 출력하지 않도록 함
	@Column(name = "USER_PASSWORD")
	private String password;
	
	@Column(name = "USER_THUMBNAIL")
	private String thumbnail;
	
	@Enumerated(EnumType.STRING) // Enum 형식을 사용하는데 String으로 넣겠다.
	@Column(name = "USER_SOCIAL_PROVIDER")
	private SocialProvider socialProvider;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "USER_ROLE")
	private Role role;
	
	@Column(name = "USER_TAGS")
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP) // 컬럼을 Timestamp 형식으로 지정하면서 현재 시간을 넣는다.
	@Column(name="USER_JOINED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date joined;
	
	public boolean isRoleAdmin(){
		return this.role.equals(Role.ROLE_ADMIN);
	}
	
	@Data
	public static class Create{
		@NotBlank
		private String id;
		@Size(min=8)
		@Pattern(regexp="^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$")
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
		@Pattern(regexp="^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$")
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


