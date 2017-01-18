package com.kdev.app.user.domain;

import java.util.Date;

import com.kdev.app.user.enums.SocialProvider;

import lombok.Data;

@Data
public class RestrictionDTO {
	private SocialProvider provider;
	private String userid;
	private String reason;
	private Date released;
}
