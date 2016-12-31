package com.kdev.app.domain;

import java.util.Collection;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.kdev.app.enums.CodeType;

import lombok.Data;

@Entity
@Table(name = "codes")
@Data
public class Code {
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int id;

	@ManyToOne
	private Code parent;
	private String name;
	private String href;
	
	@Enumerated(EnumType.STRING)
	private CodeType code;
	
	@OneToMany(fetch=FetchType.EAGER)
	@JoinColumn(name = "parent", nullable = true)
	private Collection<Code> child;
}
