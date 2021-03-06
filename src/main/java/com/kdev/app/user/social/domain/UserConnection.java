package com.kdev.app.user.social.domain;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import lombok.Data;
/**
 * 
 * @author K
 * Spring Social UserConnection Table
 */
@Entity
@Table(name="USERCONNECTION",
		uniqueConstraints = {
			@UniqueConstraint(columnNames = { "userId", "providerId", "providerUserId" }),
			@UniqueConstraint(columnNames = { "userId", "providerId", "rank" }) 
		})
@Data
public class UserConnection {
	@Id
	private UserConnectionPK primaryKey;
	private String accessToken;
	private String displayName;
	private Long expireTime;
	private String imageUrl;
	private String profileUrl;
	private int rank;
	private String refreshToken;
	private String secret;
}
