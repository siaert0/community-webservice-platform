package com.kdev.app.controller;

import java.security.Principal;
import java.util.Date;

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
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kdev.app.domain.dto.CommentDTO;
import com.kdev.app.domain.vo.Comment;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.service.CommentRepositoryService;
import com.kdev.app.service.UserRepositoryService;

@Controller
public class CommentController {
	private static Logger logger = LoggerFactory.getLogger(CommentController.class);
	
	@Autowired
	private CommentRepositoryService commentRepositoryService;
	
	@Autowired
	private UserRepositoryService userRepositroyService;
	
	@Autowired 
	ModelMapper modelMapper;
	
	/**
	 * @author		: K
	 * @method		: createComment
	 * @description	: 게시물 작성하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/comment", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createComment(@RequestBody @Valid CommentDTO.Create createComment, BindingResult result, Principal principal){
		if(result.hasErrors()){
			return new ResponseEntity<Object>(result.getAllErrors().toString(), HttpStatus.BAD_REQUEST);
		}
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		createComment.setUser(userVO);
		Comment createdComment = commentRepositoryService.create(createComment);
		createdComment = commentRepositoryService.findOne(createdComment.getId());
		createdComment.setCreated(new Date());
		return new ResponseEntity<Object>(createdComment, HttpStatus.CREATED);
	}
		
	/**
	 * @author		: K
	 * @method		: findComment
	 * @description	: 댓글 가져오기 & 페이징
	 */
	@RequestMapping(value="/comment", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findComment(@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 1000) Pageable pageable, @RequestParam int board_id){
		Page<Comment> page = commentRepositoryService.findAll(pageable, board_id);
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: updateComment
	 * @description	: 댓글 수정하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/comment/{id}", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateComment(@PathVariable int id, @RequestBody CommentDTO.Update update, Principal principal){
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		Comment commentVO = commentRepositoryService.findOne(id);
		
		if(!(commentVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(null, HttpStatus.FORBIDDEN);
		commentVO.setDescription(update.getDescription());
		commentVO.setTags(update.getTags());
		Comment updated = commentRepositoryService.update(commentVO);
		return new ResponseEntity<Object>(updated, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteComment
	 * @description	: 댓글 삭제하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/comment/{id}", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteComment(@PathVariable int id, Principal principal){
		
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		Comment commentVO = commentRepositoryService.findOne(id);
		
		if(!(commentVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(commentVO, HttpStatus.FORBIDDEN);
		
		commentRepositoryService.delete(id);
		return new ResponseEntity<Object>(commentVO, HttpStatus.ACCEPTED);
		
	}
}
