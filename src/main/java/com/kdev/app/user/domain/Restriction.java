package com.kdev.app.user.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.kdev.app.user.enums.SocialProvider;

import lombok.Data;

@Entity
@Table(name = "RESTRICTIONS")
@Data
public class Restriction {
    @EmbeddedId
	private PROVIDER_USER_CP_ID PROVIDER_USER_CP_ID;
    
    @Column(name = "USER_PROVIDER", insertable=false, updatable=false)
    @Enumerated(EnumType.STRING)
    private SocialProvider provider;
    
    @Column(name = "USER_ID", insertable=false, updatable=false)
    private String userid;
    
    @Column(name = "RT_REASOM")
    private String reason;
    
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="RT_CREATED", insertable=false, updatable=false, columnDefinition="TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private Date created;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="RT_RELEASED")
	private Date released;
	
	@Data
	public static class Create {
		private SocialProvider provider;
		private String userid;
		private String reason;
		private Date released;
	}
}
