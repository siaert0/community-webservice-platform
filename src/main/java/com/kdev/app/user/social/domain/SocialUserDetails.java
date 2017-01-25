package com.kdev.app.user.social.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.social.security.SocialUser;

import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.enums.Role;
import com.kdev.app.user.enums.SocialProvider;

import lombok.Getter;
import lombok.Setter;

/**
 * @author KDEV
 * @date 2017. 1. 26.
 * @description 사용자 정보 객체 통합
 */
@Getter
@Setter
public class SocialUserDetails extends SocialUser {

	private static final long serialVersionUID = 855226823777023437L;

	private String id;
	private String email;
    private String nickname;
    private String thumbnail;
	private String tags;
	private Role role;
    private SocialProvider socialSignInProvider;
 
    public SocialUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }
    
    public SocialUserDetails(UserVO user) {
    	super(user.getEmail(), user.getPassword(), authorities(user));
    	
		this.id = user.getId();
		this.email = user.getEmail();
		this.nickname = user.getNickname();
		this.thumbnail = user.getThumbnail();
		this.tags = user.getTags();
		this.role = user.getRole();
		this.socialSignInProvider = user.getSocialProvider();
    }
    
    public static class Builder {
        private String id;
        private String username;
        private String nickname;
        private String password;
        private String thumbnail;
        private Role role;
        private SocialProvider socialSignInProvider;
        private Set<GrantedAuthority> authorities;
 
        public Builder() {
            this.authorities = new HashSet<>();
        }
 
        public Builder nickName(String nickName) {
            this.nickname = nickName;
            return this;
        }
 
        public Builder id(String id) {
            this.id = id;
            return this;
        }
 
        public Builder password(String password) {
            if (password == null) {
                password = "SocialUser";
            }
            this.password = password;
            return this;
        }
 
        public Builder role(Role role) {
            this.role = role;
            SimpleGrantedAuthority authority = new SimpleGrantedAuthority(role.toString());
            this.authorities.add(authority);
            return this;
        }
 
        public Builder socialSignInProvider(SocialProvider socialSignInProvider) {
            this.socialSignInProvider = socialSignInProvider;
            return this;
        }
 
        public Builder username(String username) {
            this.username = username;
            return this;
        }
        
        public Builder thumbnail(String thumbnail) {
            this.thumbnail = thumbnail;
            return this;
        }
 
        public SocialUserDetails build() {
            SocialUserDetails user = new SocialUserDetails(username, password, authorities);
            user.id = id;
            user.nickname = nickname;
            user.role = role;
            user.socialSignInProvider = socialSignInProvider;
            user.thumbnail = thumbnail;
            return user;
        }
    }
    
	private static Collection<? extends GrantedAuthority> authorities(UserVO userVO) {
		// TODO Auto-generated method stub
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		authorities.add(new SimpleGrantedAuthority(userVO.getRole().toString()));
		return authorities;
	}
}
