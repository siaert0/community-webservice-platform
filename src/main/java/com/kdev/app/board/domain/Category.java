package com.kdev.app.board.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Entity
@Table(name = "CATEGORIES")
@Data
public class Category {
	@Id
	@Column(name="CT_NAME")
	private String name;
}
