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
import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.social.domain.SocialUserDetails;

/**
 * <pre>
 * com.kdev.app.board.controller
 * ScrapController.java
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
public class ScrapController {
	private static Logger logger = LoggerFactory.getLogger(ScrapController.class);
	
	private BoardRepositoryService boardRepositoryService;
	
	private ModelMapper modelMapper;
	
	public ScrapController(BoardRepositoryService boardRepositoryService, ModelMapper modelMapper) {
		this.boardRepositoryService = boardRepositoryService;
		this.modelMapper = modelMapper;
	}
	
	/**
	 * ==============================================
	 *	게시물 스크랩 RESTful API + JSON
	 * ==============================================
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> checkScrap(@RequestBody BOARD_USER_CP_ID BOARD_USER_CP_ID, Authentication authentication){
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		BOARD_USER_CP_ID.setUserid(userVO.getId());
		boardRepositoryService.checkScrap(BOARD_USER_CP_ID);
		return new ResponseEntity<Object>("스크랩 완료", HttpStatus.ACCEPTED);
	}
	
	/**
	 * ==============================================
	 *	스크랩 취소 RESTful API + JSON
	 * ==============================================
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteScrap(@RequestBody BOARD_USER_CP_ID scrapId, Authentication authentication){
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		scrapId.setUserid(userVO.getId());
		boardRepositoryService.deleteScrap(scrapId);
		return new ResponseEntity<Object>("스크랩 취소", HttpStatus.ACCEPTED);
	}
	
	/**
	 * ==============================================
	 *	스크랩 페이지
	 * ==============================================
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap", method=RequestMethod.GET)
	public String findScrapUser(Model model, Authentication authentication){
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		model.addAttribute("scrapUser", userVO.getId());
		return "board/scrap";
	}
	
	/**
	 * ==============================================
	 *	스크랩 리스트 RESTful API + JSON
	 * ==============================================
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/scrap/{user}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findScrap(@PathVariable String user, @PageableDefault(sort = { "board" }, direction = Direction.DESC, size = 5) Pageable pageable, Authentication authentication){
		Page<Scrap> page = null;
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		
		if(user.equals(""))
			return new ResponseEntity<Object>(page, HttpStatus.NOT_ACCEPTABLE);
		
		page = boardRepositoryService.findScrapByUser(userVO, pageable);
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
}
