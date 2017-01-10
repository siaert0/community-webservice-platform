package com.kdev.app.domain.pk;

import java.io.Serializable;

import javax.persistence.Embeddable;

import lombok.Data;

@Embeddable
@Data
public class UserConnectionPK implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String providerId;
	private String providerUserId;
}