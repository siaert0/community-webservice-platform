package com.kdev.app.websocket.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

/**
 * <pre>
 * com.kdev.app.websocket.config
 * WebsocketConfig.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2017. 3. 6.
 * @updated 2017. 3. 6.
 * @history -
 * ==============================================
 *	스프링 웹 소켓 설정 클래스
 * ==============================================
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebsocketConfig extends AbstractWebSocketMessageBrokerConfigurer {

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		// TODO Auto-generated method stub
		registry.addEndpoint("/websocket").withSockJS();
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		// TODO Auto-generated method stub
		registry.enableSimpleBroker("/notification");
		registry.setApplicationDestinationPrefixes("/message"); // 메시지를 받을 컨트롤러 앞
	}
}