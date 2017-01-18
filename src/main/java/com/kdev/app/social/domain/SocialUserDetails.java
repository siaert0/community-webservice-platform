package com.kdev.app.social.domain;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.social.security.SocialUser;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SocialUserDetails extends SocialUser {

	private static final long serialVersionUID = 855226823777023437L;

	private String id;
    private String nickname;
    private String role;
    private String thumbnail;
    private String socialSignInProvider;
 
    public SocialUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
    }
 
    //Getters are omitted for the sake of clarity.
    public static class Builder {
        private String id;
        private String username;
        private String nickname;
        private String password;
        private String thumbnail;
        private String role;
        private String socialSignInProvider;
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
 
        public Builder role(String role) {
            this.role = role;
            SimpleGrantedAuthority authority = new SimpleGrantedAuthority(role.toString());
            this.authorities.add(authority);
            return this;
        }
 
        public Builder socialSignInProvider(String socialSignInProvider) {
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
}
