package com.kdev.app.domain.dto;

import java.util.Date;

import com.kdev.app.enums.SocialProvider;

import lombok.Data;

@Data
public class RestrictionDTO {
	private SocialProvider provider;
	private String userid;
	private String reason;
	private Date released;
}
