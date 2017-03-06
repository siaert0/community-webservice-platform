package com.kdev.app.websocket.domain;

import com.kdev.app.user.domain.UserVO;

import lombok.Data;

/**
 * <pre>
 * com.kdev.app.websocket.domain
 * Message.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2017. 3. 6.
 * @updated 2017. 3. 6.
 * @history -
 * ==============================================
 *	웹 소켓 메시지 클래스
 * ==============================================
 */

@Data
public class Message {
	String message;
	String href;
	UserVO user;
}
