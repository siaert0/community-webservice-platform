package com.kdev.app.domain.vo;

import java.util.Collection;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.Data;

@Entity
@Table(name = "boards")
@Data
public class Board {
	
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
	
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY)
	private Collection<Comment> comments;
	
	// http://stackoverflow.com/questions/29952386/embedded-id-and-repeated-column-in-mapping-for-entity-exception
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY)
	private Collection<Thumb> thumbs;
	
    @JsonBackReference
	@OneToMany(mappedBy="board", fetch=FetchType.LAZY)
	private Collection<Scrap> scraps;
	
}
