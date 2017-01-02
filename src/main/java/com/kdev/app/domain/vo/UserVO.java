package com.kdev.app.domain.vo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.kdev.app.enums.Role;
import com.kdev.app.enums.SocialProvider;

import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class UserVO {
	@Id
	@Column(name = "id", length=155)
	private String id;
	private String email;
	private String nickname;
	
	@JsonIgnore // JSON으로 응답시에 출력하지 않도록 함
	private String password;
	private String thumbnail;
	
	@Enumerated(EnumType.STRING) // Enum 형식을 사용하는데 String으로 넣겠다.
	private SocialProvider socialSignInProvider;
	@Enumerated(EnumType.STRING)
	private Role role;
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP) // 컬럼을 Timestamp 형식으로 지정하면서 현재 시간을 넣는다.
	@Column(name="joined", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date joined;
}


