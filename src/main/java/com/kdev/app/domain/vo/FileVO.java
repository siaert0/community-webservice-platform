package com.kdev.app.domain.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FileVO {
	private int id;
	private String originalname;
	private String filename;
	private String filepath;
	private String extension;
	private UserVO user;
	private Date created;
}
