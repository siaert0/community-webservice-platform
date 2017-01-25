package com.kdev.app.board.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.kdev.app.user.domain.UserVO;

import lombok.Data;

@Entity
@Table(name = "COMMENTS")
@Data
public class Comment {
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="CM_ID")
	private int id;
	
	@Column(name="CM_DESCRIPTION", columnDefinition = "TEXT")
	private String description;
	
	@Column(name="CM_TAGS")
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date created;
	
	@ManyToOne
	@JoinColumn(name = "CM_USER_ID", referencedColumnName = "USER_ID")
    private UserVO user;
	
	@Column(name = "BD_ID")
	private int board;
	
	@Data
	public static class Create{
		private String description;
		private String tags;
		private UserVO user;
		private int board;
	}
	
	@Data
	public static class Update{
		private int id;
		private String description;
		private String tags;
		private int board;
		private UserVO user;
	}
}
