package com.kdev.app.board.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Board;
import com.kdev.app.board.domain.Comment;
import com.kdev.app.board.exception.BoardNotFoundException;
import com.kdev.app.board.exception.ValidErrorException;
import com.kdev.app.board.service.BoardRepositoryService;
import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.exception.UserNotEqualException;
import com.kdev.app.user.social.domain.SocialUserDetails;

@Controller
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	@RequestMapping(value="/board/category/{category}", method = RequestMethod.GET)
	public String category(Model model, @PathVariable String category){
		model.addAttribute("category", category);
		return "board/list";
	}
	
	/**
	 * @author		: K
	 * @method		: board_form
	 * @description	: 게시물 작성 페이지 호출, 로그인된 유저만 접근
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board", method=RequestMethod.GET)
	public String board_form(Model model){
		return "board/form";
	}
	/**
	 * @author		: K
	 * @method		: findBoardOne
	 * @description	: 해당 번호의 게시물 페이지 호출, 없을 경우 404 에러처리
	 */
	
	@RequestMapping(value="/board/{id}", method=RequestMethod.GET)
	public String findBoardOne(@PathVariable int id, Model model){
		Board boardVO = boardRepositoryService.findBoardOne(id);	
		if(boardVO == null)
			throw new BoardNotFoundException();
		model.addAttribute("content", boardVO);
		return "board/detail";
	}
	
	/**
	 * @author		: K
	 * @method		: findBoardOne
	 * @description	: 해당 번호의 게시물 서비스, JSON
	 */
	
	@RequestMapping(value="/board/{id}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoardOneREST(@PathVariable int id){
		
		Board boardVO = boardRepositoryService.findBoardOne(id);
		if(boardVO == null){
			throw new BoardNotFoundException();
		}
		
		return new ResponseEntity<Object>(boardVO, HttpStatus.OK);
	}
	
	/**
	 * @author		: K
	 * @method		: createBoard
	 * @description	: 게시물 생성 API
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createBoard(@RequestBody @Valid Board.Create createBoard, BindingResult result, Authentication authentication){
		
		// 게시물 작성 시 필요한 정보 검증
		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			result.getFieldErrors().forEach(error ->{
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
			});
			throw new ValidErrorException(errors.toString());
		}
		
		// 사용자 정보 저장 (스프링 시큐리티에 의해 검증되어져 있음)
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		createBoard.setUser(userVO);
		
		// 게시물 생성 요청
		Board createdBoard = boardRepositoryService.createBoard(createBoard);
		
		// 생성한 게시물을 자동으로 스크랩 처리
		BOARD_USER_CP_ID scrapId = new BOARD_USER_CP_ID();
		scrapId.setBoardid(createdBoard.getId());
		scrapId.setUserid(userVO.getId());
		boardRepositoryService.checkScrap(scrapId);
		
		return new ResponseEntity<Object>(createdBoard, HttpStatus.CREATED);
	}
		
	/**
	 * @author		: K
	 * @method		: findBoard
	 * @description	: 게시물 가져오기 & 페이징 서비스 + 검색 기능 추가
	 */
	@RequestMapping(value="/board", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoard(@RequestParam(value="category", required=false, defaultValue="") String category, 
			@RequestParam(value="search", required=false, defaultValue="") String search,
			@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 5) Pageable pageable){
		
		// 검색 요청
		Page<Board> page = boardRepositoryService.findAll(search, category, pageable);

		/**
		 *  자바 8 스트림 : 컬렉션의 저장 요소를 하나씩 참조해서 람다식으로 처리할 수 있도록 해주는 반복자
		 *  게시물과 댓글의 태그분석
		 */
		Set<String> sets = new HashSet<String>();
		page.getContent().parallelStream().forEach(board -> {
			String btags = board.getTags();
			btags = btags.replaceAll("\\[|\\]|\"", "");
			Arrays.asList(btags.split(",")).parallelStream().forEach(tag->{
				sets.add(tag);
			});;
		});
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("page", page);
		map.put("tags", sets);
		
		return new ResponseEntity<Object>(map, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: updateBoard
	 * @description	: 게시물 수정하기 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/{id}", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateBoard(@PathVariable int id, @RequestBody @Valid Board.Update update, BindingResult result, Authentication authentication){
		
		// 게시물 수정 시 필요한 정보 검증
		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			result.getFieldErrors().forEach(error ->{
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
			});
			throw new ValidErrorException(errors.toString());
		}
		
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		
		Board boardVO = boardRepositoryService.findBoardOne(id);
		
		//관리자일 경우 수정처리
		if(userVO.isRoleAdmin()){

		}else if(!(boardVO.getUser().getId().equals(userVO.getId())))
			throw new UserNotEqualException();
		
		// 게시물 수정
		boardVO.setCategory(update.getCategory());
		boardVO.setDescription(update.getDescription());
		boardVO.setTitle(update.getTitle());
		boardVO.setTags(update.getTags());
		boardVO.setSelected(update.getSelected());

		// 수정 된 게시물을 적용시킴
		Board updated = boardRepositoryService.updateBoard(boardVO);
		return new ResponseEntity<Object>(updated, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteBoard
	 * @description	: 게시물 삭제 서비스, 관련된 댓글, 스크랩, 추천 모두 삭제
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/{id}", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteBoard(@PathVariable int id, Authentication authentication){
		
		SocialUserDetails userDetails = (SocialUserDetails)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		Board boardVO = boardRepositoryService.findBoardOne(id);
		
		//관리자일 경우 삭제처리
		if(userVO.isRoleAdmin()){
			boardRepositoryService.deleteBoard(id);
			return new ResponseEntity<Object>(boardVO, HttpStatus.ACCEPTED);
		}
			
		// 작성자 여부 체크
		if(!(boardVO.getUser().getId().equals(userVO.getId())))
			throw new UserNotEqualException();
		
		boardRepositoryService.deleteBoard(id);
		return new ResponseEntity<Object>(boardVO, HttpStatus.ACCEPTED);
	}
	
	// 최근 게시물 정보 API
	@RequestMapping(value="/top", method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> topData(Model model, @PageableDefault(sort="created", direction = Direction.DESC, size = 10) Pageable pageable){
		List<Board> QA = boardRepositoryService.findAllBoardByCategory("QA", pageable).getContent();
		List<Board> REQURIT = boardRepositoryService.findAllBoardByCategory("신입공채", pageable).getContent();
		List<Comment> COMMENT = boardRepositoryService.findCommentAll(pageable).getContent();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("QA", QA);
		map.put("REQURIT", REQURIT);
		map.put("COMMENT", COMMENT);
		return new ResponseEntity<Object>(map,HttpStatus.ACCEPTED);
	}
}
