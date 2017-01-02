package com.kdev.app.domain.pk;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class ScrapId implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Column(name = "BOARD_ID")
	private int boardid;

	@Column(name = "USER_ID")
	private String userid;

	public ScrapId() {
	}
	public ScrapId(int boardid, String userid) {
		this.boardid = boardid;
		this.userid = userid;
	}
	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return super.equals(obj);
	}
	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return super.hashCode();
	}
	
	public int getBoardid() {
		return boardid;
	}
	public void setBoardid(int boardid) {
		this.boardid = boardid;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
}
