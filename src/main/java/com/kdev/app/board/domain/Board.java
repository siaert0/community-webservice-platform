package com.kdev.app.board.domain;

import java.util.Collection;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.kdev.app.user.domain.UserVO;

import lombok.Data;

@Entity
@Table(name = "BOARDS")
@Data
public class Board {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="BD_ID")
	private int id;
	
	@Column(name="BD_TITLE")
	private String title;
	
	@Column(name="BD_DESCRIPTION", columnDefinition = "TEXT")
	private String description;
	
	@Column(name="BD_CATEGORY")
	private String category;
	
	@Column(name="CM_SELECTED")
	private int selected;
	
	@Column(name="BD_TAGS")
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="BD_CREATED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date created;
	
	@ManyToOne
	@JoinColumn(name = "BD_USER_ID", referencedColumnName = "USER_ID")
    private UserVO user;
	
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY, cascade=CascadeType.REMOVE)
	@OrderBy("id DESC")
	private Collection<Comment> comments;
	
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY, cascade=CascadeType.REMOVE)
	private Collection<Thumb> thumbs;
	
	//Infinity Recursion 방지
    @JsonBackReference
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY, cascade=CascadeType.REMOVE)
	private Collection<Scrap> scraps;
    
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
