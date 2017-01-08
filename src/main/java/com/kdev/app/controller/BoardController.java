package com.kdev.app.controller;

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

import com.kdev.app.domain.dto.BoardDTO;
import com.kdev.app.domain.dto.CommentDTO;
import com.kdev.app.domain.pk.BOARD_USER_CP_ID;
import com.kdev.app.domain.vo.Board;
import com.kdev.app.domain.vo.Comment;
import com.kdev.app.domain.vo.Scrap;
import com.kdev.app.domain.vo.Thumb;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.exception.badgateway.ValidErrorException;
import com.kdev.app.exception.forbidden.UserNotEqualException;
import com.kdev.app.exception.notfound.BoardNotFoundException;
import com.kdev.app.service.BoardRepositoryService;

@Controller
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	
	/**
	 * ######################
	 * 		게시물 관련 서비스
	 * ######################
	 */
	
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
	 * @description	: 게시물 작성 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createBoard(@RequestBody @Valid BoardDTO.Create createBoard, BindingResult result, Authentication authentication){
		
		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			for(FieldError error : result.getFieldErrors()){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
			}
			throw new ValidErrorException(errors.toString());
		}
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		createBoard.setUser(userVO);
		Board createdBoard = boardRepositoryService.createBoard(createBoard);
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
		Page<Board> page = boardRepositoryService.findAll(search, category, pageable);

		/**
		 *  자바 8 스트림 : 컬렉션의 저장 요소를 하나씩 참조해서 람다식으로 처리할 수 있도록 해주는 반복자
		 *  게시물과 댓글의 태그분석
		 */
		Stream<Board> parallelStream = page.getContent().parallelStream();
		Set<String> sets = new HashSet<String>();
		parallelStream.forEach(board -> {
			String btags = board.getTags();
			btags = btags.replaceAll("\\[", "");
			btags = btags.replaceAll("\\]", "");
			btags = btags.replaceAll("\"", "");
			Arrays.asList(btags.split(",")).parallelStream().forEach(tag->{
				sets.add(tag);
			});;
			
			
			/*
			  board.getComments().parallelStream().map(Comment ::getTags).forEach(tags ->{
				tags = tags.replaceAll("\\[", "");
				tags = tags.replaceAll("\\]", "");
				tags = tags.replaceAll("\"", "");
				Arrays.asList(tags.split(",")).parallelStream().forEach(tag->{
					sets.add(tag);
				});;
				
			});
			*/
		});
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("page", page);
		map.put("tags", sets);
		
		return new ResponseEntity<Object>(map, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: findBoardByUser
	 * @description	: 사용자가 작성한 게시물 가져오기 & 페이징 서비스 [사용안함]
	 */
	@RequestMapping(value="/board/user/{userid}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoardByUser(@PathVariable String userid,@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 1000) Pageable pageable){
		UserVO userVO = new UserVO();
		userVO.setId(userid);
		Page<Board> page = boardRepositoryService.findAllBoardByUser(userVO, pageable);
		List<Board> list = page.getContent();
		return new ResponseEntity<Object>(list, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: updateBoard
	 * @description	: 게시물 수정하기 서비스
	 */
	@Secured({"ROLE_USER","ROLE_ADMIN"})
	@RequestMapping(value="/board/{id}", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateBoard(@PathVariable int id, @RequestBody @Valid BoardDTO.Update update, BindingResult result, Authentication authentication){
		
		if(result.hasErrors()){
			List<Object> errors = new LinkedList<Object>();
			for(FieldError error : result.getFieldErrors()){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ErrorField", error.getField());
				map.put("ErrorMessage", error.getDefaultMessage());
				errors.add(map);
			}
			throw new ValidErrorException(errors.toString());
		}
		
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		
		Board boardVO = boardRepositoryService.findBoardOne(id);
		
		//관리자일 경우 수정처리
		if(userVO.isRoleAdmin()){

		}else if(!(boardVO.getUser().getId().equals(userVO.getId())))
			throw new UserNotEqualException();
		
		boardVO.setCategory(update.getCategory());
		boardVO.setDescription(update.getDescription());
		boardVO.setTitle(update.getTitle());
		boardVO.setTags(update.getTags());
		boardVO.setSelected(update.getSelected());

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
		
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
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
