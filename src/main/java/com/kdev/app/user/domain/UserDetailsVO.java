package com.kdev.app.user.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import com.kdev.app.user.enums.Role;
import com.kdev.app.user.enums.SocialProvider;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDetailsVO extends User {
	private static final long serialVersionUID = -8528470561188776344L;
	
	private String id;
	private String email;
	private String nickname;
	private SocialProvider socialProvider;
	private String thumbnail;
	private String tags;
	private Role role;

	public UserDetailsVO(UserVO user) {
		super(user.getEmail(), user.getPassword(), authorities(user));
		this.id = user.getId();
		this.nickname = user.getNickname();
		this.thumbnail = user.getThumbnail();
		this.socialProvider = user.getSocialProvider();
		this.tags = user.getTags();
		this.email = user.getEmail();
		this.role = user.getRole();
		// TODO Auto-generated constructor stub
	}

	private static Collection<? extends GrantedAuthority> authorities(UserVO userVO) {
		// TODO Auto-generated method stub
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority(userVO.getRole().toString()));
		return authorities;
	}
}
