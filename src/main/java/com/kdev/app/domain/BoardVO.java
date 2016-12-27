package com.kdev.app.domain;

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
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "boards")
@Getter
@Setter
public class BoardVO {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int id;
	private String title;
	
	@Column(columnDefinition = "TEXT")
	private String description;
	private String category;
	private int selected;
	private String tags;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="created", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date created;
	
	@ManyToOne
	@PrimaryKeyJoinColumn(name = "userid", referencedColumnName = "id")
    private UserVO user;
	
	@OneToMany(fetch=FetchType.EAGER)
	@JoinColumn(name = "boardid")
	private Collection<CommentVO> comments;
}
