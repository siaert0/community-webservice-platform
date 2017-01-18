package com.kdev.app.board.controller;

import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.validation.Valid;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Board;
import com.kdev.app.board.domain.BoardDTO;
import com.kdev.app.board.domain.Comment;
import com.kdev.app.board.domain.CommentDTO;
import com.kdev.app.board.domain.Scrap;
import com.kdev.app.board.domain.Thumb;
import com.kdev.app.board.exception.BoardNotFoundException;
import com.kdev.app.board.exception.ValidErrorException;
import com.kdev.app.board.service.BoardRepositoryService;
import com.kdev.app.user.domain.UserDetailsVO;
import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.exception.UserNotEqualException;

@Controller
public class ThumbController {
	private static Logger logger = LoggerFactory.getLogger(ThumbController.class);
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	/**
	 * ######################
	 * 		추천 관련 서비스
	 * ######################
	 */

	/**
	 * @author		: K
	 * @method		: checkThumb
	 * @description	: 게시물 추천 및 취소 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/thumb", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> checkThumb(@RequestBody BOARD_USER_CP_ID BOARD_USER_CP_ID, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		BOARD_USER_CP_ID.setUserid(userVO.getId());
		boardRepositoryService.checkThumb(BOARD_USER_CP_ID);
		List<Thumb> thumbs = boardRepositoryService.findThumbByBoard(BOARD_USER_CP_ID.getBoardid());
		return new ResponseEntity<Object>(thumbs, HttpStatus.ACCEPTED);
	}
}
