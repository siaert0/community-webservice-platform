package com.kdev.app.user.social.config;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.encrypt.Encryptors;
import org.springframework.social.UserIdSource;
import org.springframework.social.config.annotation.ConnectionFactoryConfigurer;
import org.springframework.social.config.annotation.SocialConfigurer;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.connect.UsersConnectionRepository;
import org.springframework.social.connect.jdbc.JdbcUsersConnectionRepository;
import org.springframework.social.connect.web.ConnectController;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.kakao.api.Kakao;
import org.springframework.social.kakao.connect.KakaoConnectionFactory;
import org.springframework.social.security.AuthenticationNameUserIdSource;

import com.kdev.app.user.controller.SocialConnectController;

/**
 * <pre>
 * com.kdev.app.user.social.config
 * SocialConfig.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 
 * @updated 2017. 3. 6. 소스 설명을 위한 주석 추가
 * @history -
 * ==============================================
 *	Spring Social Configuration Class
 * ==============================================
 */
@Configuration
public class SocialConfig implements SocialConfigurer {

	@Autowired
	private DataSource dataSource;
	
	/**
	 * ==============================================
	 *	소셜 프로바이더를 커넥션 팩토리 클래스에 주입합니다. 
	 *	주의) 페이스북은 spring-social-facebook를 통해 자동으로 주입되어집니다. 
	 * ==============================================
	 */
	@Override
	public void addConnectionFactories(ConnectionFactoryConfigurer connectionFactoryConfigurer, Environment environment) {
		// TODO Auto-generated method stub	
		connectionFactoryConfigurer.addConnectionFactory(new KakaoConnectionFactory(
	            environment.getProperty("spring.social.kakao.app-id")));
	}
	
	/**
	 * ==============================================
	 *	소셜 커넥션 정보를 데이터베이스로 관리합니다.
	 *	user.social.domain.UserConnection 클래스에 의해 커넥션을 위한 테이블이 생성되어집니다.
	 * ==============================================
	 */
	@Override
	public UsersConnectionRepository getUsersConnectionRepository(ConnectionFactoryLocator connectionFactoryLocator) {
		// TODO Auto-generated method stub
		JdbcUsersConnectionRepository repository = new JdbcUsersConnectionRepository(dataSource, connectionFactoryLocator, Encryptors.noOpText());
		return repository;
	}

	@Override
	public UserIdSource getUserIdSource() {
		// TODO Auto-generated method stub
		return new AuthenticationNameUserIdSource();
	}
	
	@Bean
    public ConnectController connectController(
                ConnectionFactoryLocator connectionFactoryLocator,
                ConnectionRepository connectionRepository) {
		SocialConnectController controller = new SocialConnectController(connectionFactoryLocator, connectionRepository);
	        return controller;
    }
	
	@Bean
	@Scope(value="request", proxyMode=ScopedProxyMode.INTERFACES)
	public Facebook facebook(ConnectionRepository repository) {
		Connection<Facebook> connection = repository.findPrimaryConnection(Facebook.class);
		return connection != null ? connection.getApi() : null;
	}
	
	@Bean
	@Scope(value="request", proxyMode=ScopedProxyMode.INTERFACES)
	public Kakao kakao(ConnectionRepository repository) {
		Connection<Kakao> connection = repository.findPrimaryConnection(Kakao.class);
		return connection != null ? connection.getApi() : null;
	}
}