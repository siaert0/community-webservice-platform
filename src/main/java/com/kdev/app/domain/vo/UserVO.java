package com.kdev.app.domain.vo;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "users")
@Getter
@Setter
public class UserVO {
	@Id
	@Column(name = "id", length=155)
	private String id;
	private String email;
	private String nickname;
	
	@JsonIgnore
	private String password;
	private String thumbnail;
	private String role;
	private String socialSignInProvider;
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="joined", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date joined;
}
