package com.kdev.app.domain.pk;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;

import com.kdev.app.enums.SocialProvider;

import lombok.Data;

@Embeddable
@Data
public class PROVIDER_USER_CP_ID implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Column(name = "USER_PROVIDER")
	@Enumerated(EnumType.STRING)
	private SocialProvider provider;

	@Column(name = "USER_ID")
	private String userid;

	public PROVIDER_USER_CP_ID(SocialProvider provider, String userid) {
		this.provider = provider;
		this.userid = userid;
	}

	public PROVIDER_USER_CP_ID() {
	}
}
