package com.kdev.app.security.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.kdev.app.security.handler.LoginAuthenticationSuccessHandler;
import com.kdev.app.user.service.UserRepositoryService;

/**
 * <pre>
 * com.kdev.app.security.config
 * SecurityConfig.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2016. 12. 27.
 * @updated 2017. ?. ?.
 * @history -
 * ==============================================
 *	
 * ==============================================
 */
@Configuration
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	private UserRepositoryService userRepositoryService;
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		// TODO Auto-generated method stub
		http
		.authorizeRequests()
			.antMatchers("/admin/**").hasRole("ADMIN")
			.antMatchers("/**").permitAll()
		.and()
			.formLogin()
				.loginPage("/login")
				.defaultSuccessUrl("/")
				.successHandler(successHandler())
				.permitAll()
		.and()
			.logout()
				.logoutUrl("/logout")
				.logoutSuccessUrl("/")
		.and()
			.httpBasic();
		
		http.sessionManagement().maximumSessions(1);
	}

	@Override
	public void configure(WebSecurity web) throws Exception {
		// TODO Auto-generated method stub
		web.ignoring()
				.antMatchers("/static/**","/resources/**");
	}
	
	@Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(userRepositoryService).passwordEncoder(passwordEncoder());
    }
	
	@Bean
	public PasswordEncoder passwordEncoder(){
		return new BCryptPasswordEncoder();
	}
    
	@Bean
	public AuthenticationSuccessHandler successHandler(){
		return new LoginAuthenticationSuccessHandler("/");
	}
}
