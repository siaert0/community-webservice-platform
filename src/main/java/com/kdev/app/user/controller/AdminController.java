package com.kdev.app.user.controller;

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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.board.repository.BoardRepository;
import com.kdev.app.board.repository.CommentRepository;
import com.kdev.app.board.repository.ThumbRepository;
import com.kdev.app.user.domain.PROVIDER_USER_CP_ID;
import com.kdev.app.user.domain.Restriction;
import com.kdev.app.user.enums.SocialProvider;
import com.kdev.app.user.exception.UserNotFoundException;
import com.kdev.app.user.repositroy.RestrictionRepository;
import com.kdev.app.user.repositroy.UserRepository;
import com.kdev.app.user.service.UserRepositoryService;

/**
 * @package		: com.kdev.app.controller
 * @filename	: AdminController.java
 * @author		: K
 * @date 		: 2017. 01. 05.
 * @description	: 관리자 기능 관련 컨트롤러
 */
@Controller
public class AdminController {
	private static Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private UserRepository userRepositroy;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private CommentRepository commentRepository;
	
	@Autowired
	private ThumbRepository thumbRepository;
	
	@Autowired
	private RestrictionRepository restrictionRepository;
	
	@Autowired
	private UserRepositoryService userRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	@RequestMapping(value="/admin", method = RequestMethod.GET)
	public String home(Model model){
		model.addAttribute("userCount", userRepositroy.count());
		model.addAttribute("currentSessionCount", "NONE");
		model.addAttribute("facebookUser", userRepositroy.findBySocialProvider(SocialProvider.Facebook).size());
		model.addAttribute("kakaoUser", userRepositroy.findBySocialProvider(SocialProvider.Kakao).size());
		model.addAttribute("systemMemory", (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/(1024*1024));
		model.addAttribute("restrictCount", restrictionRepository.findAll().size());
		model.addAttribute("boardCount", boardRepository.findAll().size());
		model.addAttribute("commentCount", commentRepository.findAll().size());
		model.addAttribute("thumbCount", thumbRepository.findAll().size());
		return "admin/home";
	}
	
	//제재 리스트
	@Secured("ROLE_ADMIN")
	@RequestMapping(value="/restriction", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findRestrictionByUser(@PageableDefault(sort = { "created" }, direction = Direction.DESC, size = 10) Pageable pageable){
		Page<Restriction> restrictions = restrictionRepository.findAll(pageable);
		return new ResponseEntity<Object>(restrictions, HttpStatus.ACCEPTED);
	}
	
	// 회원 제재 등록 및 수정 회원정보를 위하여 탈퇴처리하지 않도록 수정됨
	@Secured("ROLE_ADMIN")
	@RequestMapping(value="/restriction", method = RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> restriction(@RequestBody Restriction.Create restrictionDTO){
		
		if(userRepositoryService.findUserById(restrictionDTO.getUserid()) == null)
				throw new UserNotFoundException(""); 
		
		Restriction restriction = modelMapper.map(restrictionDTO, Restriction.class);
		PROVIDER_USER_CP_ID PROVIDER_USER_CP_ID = new PROVIDER_USER_CP_ID();
		PROVIDER_USER_CP_ID.setProvider(restrictionDTO.getProvider());
		PROVIDER_USER_CP_ID.setUserid(restriction.getUserid());
		restriction.setPROVIDER_USER_CP_ID(PROVIDER_USER_CP_ID);
		restrictionRepository.save(restriction);
		return new ResponseEntity<Object>(restriction, HttpStatus.OK);
	}
	
	// 회원 제재 취소
	@Secured("ROLE_ADMIN")
	@RequestMapping(value="/restriction", method = RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> restrictionCancel(@RequestBody PROVIDER_USER_CP_ID PROVIDER_USER_CP_ID){
		
		if(restrictionRepository.findOne(PROVIDER_USER_CP_ID) == null)
			throw new UserNotFoundException("");
		
		restrictionRepository.delete(PROVIDER_USER_CP_ID);
		return new ResponseEntity<Object>(PROVIDER_USER_CP_ID, HttpStatus.OK);
	}
}
