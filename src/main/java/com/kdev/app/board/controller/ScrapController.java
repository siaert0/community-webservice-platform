package com.kdev.app.board.controller;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Scrap;
import com.kdev.app.board.service.BoardRepositoryService;
import com.kdev.app.user.domain.UserDetailsVO;
import com.kdev.app.user.domain.UserVO;

@Controller
public class ScrapController {
	private static Logger logger = LoggerFactory.getLogger(ScrapController.class);
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	/**
	 * ######################
	 * 		스크랩 관련 서비스
	 * ######################
	 */
	
	/**
	 * @author		: K
	 * @method		: checkScrap
	 * @description	: 게시물 스크랩 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> checkScrap(@RequestBody BOARD_USER_CP_ID BOARD_USER_CP_ID, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		BOARD_USER_CP_ID.setUserid(userVO.getId());
		boardRepositoryService.checkScrap(BOARD_USER_CP_ID);
		return new ResponseEntity<Object>("스크랩 완료", HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteScrap
	 * @description	: 게시물 스크랩 취소 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteScrap(@RequestBody BOARD_USER_CP_ID scrapId, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		scrapId.setUserid(userVO.getId());
		boardRepositoryService.deleteScrap(scrapId);
		return new ResponseEntity<Object>("스크랩 취소", HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: findScrapUser
	 * @description	: 사용자가 스크랩한 게시물 페이지 호출
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap", method=RequestMethod.GET)
	public String findScrapUser(Model model, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		model.addAttribute("scrapUser", userVO.getId());
		return "board/scrap";
	}
	
	/**
	 * @author		: K
	 * @method		: findBoard
	 * @description	: 스크랩 게시물 가져오기 & 페이징
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap/{user}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findScrap(@PathVariable String user, @PageableDefault(sort = { "board" }, direction = Direction.DESC, size = 5) Pageable pageable, Authentication authentication){
		Page<Scrap> page = null;
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		
		if(user.equals(""))
			return new ResponseEntity<Object>(page, HttpStatus.NOT_ACCEPTABLE);
		else
			page = boardRepositoryService.findScrapByUser(userVO, pageable);
		
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
}
