package com.kdev.app.domain.pk;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import lombok.Data;

@Embeddable
@Data
public class BOARD_USER_CP_ID implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Column(name = "BD_ID")
	private int boardid;

	@Column(name = "USER_ID")
	private String userid;
}
