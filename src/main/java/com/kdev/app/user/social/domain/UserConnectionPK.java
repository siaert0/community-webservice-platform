package com.kdev.app.user.social.domain;

import java.io.Serializable;

import javax.persistence.Embeddable;

import lombok.Data;

@Embeddable
@Data
public class UserConnectionPK implements Serializable {
	private String userId;
	private String providerId;
	private String providerUserId;
}