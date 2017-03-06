package com.kdev.app.board.controller;

import java.util.List;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Thumb;
import com.kdev.app.board.service.BoardRepositoryService;
import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.social.domain.SocialUserDetails;

/**
 * <pre>
 * com.kdev.app.board.controller
 * ThumbController.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2017. 3. 6.
 * @updated 2017. 3. 6.
 * @history -
 * ==============================================
 *	2017. 3. 6. -> @Autowird 주입에서 생성자 주입 방식으로 변경
 * ==============================================
 */
@Controller
public class ThumbController {
	private static Logger logger = LoggerFactory.getLogger(ThumbController.class);
	
	private BoardRepositoryService boardRepositoryService;
	
	private ModelMapper modelMapper;
	
	public ThumbController(BoardRepositoryService boardRepositoryService, ModelMapper modelMapper) {
		this.boardRepositoryService = boardRepositoryService;
		this.modelMapper = modelMapper;
	}

	/**
	 * ==============================================
	 *	게시물 추천 및 취소 RESTful API + JSON
	 * ==============================================
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/thumb", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> checkThumb(@RequestBody BOARD_USER_CP_ID BOARD_USER_CP_ID, Authentication authentication){
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		BOARD_USER_CP_ID.setUserid(userVO.getId());
		boardRepositoryService.checkThumb(BOARD_USER_CP_ID);
		List<Thumb> thumbs = boardRepositoryService.findThumbByBoard(BOARD_USER_CP_ID.getBoardid());
		return new ResponseEntity<Object>(thumbs, HttpStatus.ACCEPTED);
	}
}
