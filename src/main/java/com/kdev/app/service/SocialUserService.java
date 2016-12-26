package com.kdev.app.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.social.security.SocialUserDetails;
import org.springframework.social.security.SocialUserDetailsService;

public class SocialUserService implements SocialUserDetailsService {
	private UserDetailsService userDetailsService;
	
	public SocialUserService(UserDetailsService userDetailsService) {
		// TODO Auto-generated constructor stub
		this.userDetailsService = userDetailsService;
	}
	
	@Override
	public SocialUserDetails loadUserByUserId(String userId) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		UserDetails userDetails = userDetailsService.loadUserByUsername(userId);
		return (SocialUserDetails) userDetails;
	}
}