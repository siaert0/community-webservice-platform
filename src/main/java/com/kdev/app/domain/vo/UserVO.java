package com.kdev.app.domain.vo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.kdev.app.enums.Role;
import com.kdev.app.enums.SocialProvider;

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
}


