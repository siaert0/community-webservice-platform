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
public class CommentController {
	private static Logger logger = LoggerFactory.getLogger(CommentController.class);
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	
	/**
	 * ######################
	 * 		댓글 관련 서비스
	 * ######################
	 */
	
	/**
	 * @author		: K
	 * @method		: createComment
	 * @description	: 댓글 작성 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/comment", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createComment(@RequestBody @Valid CommentDTO.Create createComment, BindingResult result, Authentication authentication){
		if(result.hasErrors()){
			throw new ValidErrorException(result.getAllErrors().toString());
		}
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		createComment.setUser(userVO);
		Comment createdComment = boardRepositoryService.createComment(createComment);
		createdComment = boardRepositoryService.findCommentOne(createdComment.getId());
		createdComment.setCreated(new Date());
		return new ResponseEntity<Object>(createdComment, HttpStatus.CREATED);
	}
		
	/**
	 * @author		: K
	 * @method		: findComment
	 * @description	: 댓글 가져오기 & 페이징 서비스
	 */
	@RequestMapping(value="/comment", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findComment(@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 1000) Pageable pageable, @RequestParam int board_id){
		Page<Comment> page = boardRepositoryService.findCommentAll(pageable, board_id);
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: updateComment
	 * @description	: 댓글 수정하기 서비스 [검증 부분 추가 필요]
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/comment/{id}", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateComment(@PathVariable int id, @RequestBody CommentDTO.Update update, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		Comment commentVO = boardRepositoryService.findCommentOne(id);
		
		//관리자일 경우 수정처리
		if(userVO.isRoleAdmin()){

		}else if(!(commentVO.getUser().getId().equals(userVO.getId())))
			throw new UserNotEqualException();
		
		commentVO.setDescription(update.getDescription());
		commentVO.setTags(update.getTags());
		Comment updated = boardRepositoryService.updateComment(commentVO);
		return new ResponseEntity<Object>(updated, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteComment
	 * @description	: 댓글 삭제하기 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/comment/{id}", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteComment(@PathVariable int id, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		Comment commentVO = boardRepositoryService.findCommentOne(id);
		
		//관리자일 경우 삭제처리
		if(userVO.isRoleAdmin()){
			boardRepositoryService.deleteComment(id);
			return new ResponseEntity<Object>(commentVO, HttpStatus.ACCEPTED);
		}
		
		// 작성자 여부 체크
		if(!(commentVO.getUser().getId().equals(userVO.getId())))
			throw new UserNotEqualException();
		
		boardRepositoryService.deleteComment(id);
		return new ResponseEntity<Object>(commentVO, HttpStatus.ACCEPTED);
	}
}
