package com.kdev.app.controller;

import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import org.modelmapper.ModelMapper;
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

import com.kdev.app.domain.dto.BoardDTO;
import com.kdev.app.domain.dto.CommentDTO;
import com.kdev.app.domain.pk.BOARD_USER_CP_ID;
import com.kdev.app.domain.vo.Board;
import com.kdev.app.domain.vo.Comment;
import com.kdev.app.domain.vo.Scrap;
import com.kdev.app.domain.vo.Thumb;
import com.kdev.app.domain.vo.UserDetailsVO;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.exception.ExceptionResponse;
import com.kdev.app.exception.NotFoundException;
import com.kdev.app.exception.ValidException;
import com.kdev.app.service.BoardRepositoryService;

/**
 * @author K
 *
 */
@Controller
public class BoardController {
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/board", method=RequestMethod.GET)
	public String board_form(Model model){
		return "board/form";
	}
	
	@RequestMapping(value="/board/{id}", method=RequestMethod.GET)
	public String findBoardOne(@PathVariable int id, Model model){
		Board boardVO = boardRepositoryService.findBoardOne(id);	
		if(boardVO == null)
			throw new NotFoundException("게시물을 찾을 수 없습니다.");
		model.addAttribute("content", boardVO);
		return "board/detail";
	}

	/**
	 * @author		: K
	 * @method		: checkThumb
	 * @description	: 추천 및 취소
	 */
	@Secured("ROLE_USER")
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
	 * @author		: K
	 * @method		: checkScrap
	 * @description	: 스크랩
	 */
	@Secured("ROLE_USER")
	@RequestMapping(value="/board/scrap", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> checkScrap(@RequestBody BOARD_USER_CP_ID scrapId, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();

		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		scrapId.setUserid(userVO.getId());
		boardRepositoryService.checkScrap(scrapId);
		return new ResponseEntity<Object>("스크랩 완료", HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteScrap
	 * @description	: 스크랩 취소
	 */
	@Secured("ROLE_USER")
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
	 * @description	: 스크랩 뷰
	 */
	@Secured("ROLE_USER")
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
	@Secured("ROLE_USER")
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
	
	@RequestMapping(value="/board/{id}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoardOneREST(@PathVariable int id){
		
		Board boardVO = boardRepositoryService.findBoardOne(id);
		
		/**
		 * 에러 처리 방법 1
		 */
		if(boardVO == null){
			ExceptionResponse response = new ExceptionResponse();
			response.setRequest("요청 게시물 번호 : "+id);
			response.setResponse("해당 번호의 게시물을 찾을 수 없습니다.");
			response.setHttpStatus("404");
			return new ResponseEntity<Object>(response, HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<Object>(boardVO, HttpStatus.OK);
	}
	
	/**
	 * @author		: K
	 * @method		: createBoard
	 * @description	: 게시물 작성하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/board", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createBoard(@RequestBody @Valid BoardDTO.Create createBoard, BindingResult result, Authentication authentication){
		
		if(result.hasErrors()){
			throw new ValidException(result.getAllErrors().toString());
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
	 * @description	: 게시물 가져오기 & 페이징
	 */
	@RequestMapping(value="/board", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoard(@RequestParam(value="category", required=false, defaultValue="") String category, 
			@RequestParam(value="search", required=false, defaultValue="") String search,
			@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 5) Pageable pageable){
		Page<Board> page = boardRepositoryService.findAllByCategoryAndTitleContainingOrTagsContaining(category, search, search, pageable);
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: findBoardByUser
	 * @description	: 사용자가 작성한 게시물 가져오기 & 페이징
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
	 * @description	: 게시물 수정하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/board/{id}", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateBoard(@PathVariable int id, @RequestBody BoardDTO.Update update, Authentication authentication){
		
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		
		Board boardVO = boardRepositoryService.findBoardOne(id);
		
		if(!(boardVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(update, HttpStatus.FORBIDDEN);
		
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
	 * @description	: 게시물 삭제
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/board/{id}", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteBoard(@PathVariable int id, Authentication authentication){
		
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		Board boardVO = boardRepositoryService.findBoardOne(id);
		
		if(!(boardVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(boardVO, HttpStatus.FORBIDDEN);
		
		boardRepositoryService.deleteBoard(id);
		return new ResponseEntity<Object>(boardVO, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: createComment
	 * @description	: 게시물 작성하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/comment", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> createComment(@RequestBody @Valid CommentDTO.Create createComment, BindingResult result, Authentication authentication){
		if(result.hasErrors()){
			return new ResponseEntity<Object>(result.getAllErrors().toString(), HttpStatus.BAD_REQUEST);
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
	 * @description	: 댓글 가져오기 & 페이징
	 */
	@RequestMapping(value="/comment", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findComment(@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 1000) Pageable pageable, @RequestParam int board_id){
		Page<Comment> page = boardRepositoryService.findCommentAll(pageable, board_id);
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: updateComment
	 * @description	: 댓글 수정하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/comment/{id}", method=RequestMethod.POST, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> updateComment(@PathVariable int id, @RequestBody CommentDTO.Update update, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		Comment commentVO = boardRepositoryService.findCommentOne(id);
		
		if(!(commentVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(null, HttpStatus.FORBIDDEN);
		commentVO.setDescription(update.getDescription());
		commentVO.setTags(update.getTags());
		Comment updated = boardRepositoryService.updateComment(commentVO);
		return new ResponseEntity<Object>(updated, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteComment
	 * @description	: 댓글 삭제하기
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/comment/{id}", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteComment(@PathVariable int id, Authentication authentication){
		UserDetailsVO userDetails = (UserDetailsVO)authentication.getPrincipal();
		UserVO userVO = modelMapper.map(userDetails, UserVO.class);
		Comment commentVO = boardRepositoryService.findCommentOne(id);
		if(!(commentVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(commentVO, HttpStatus.FORBIDDEN);
		
		boardRepositoryService.deleteComment(id);
		return new ResponseEntity<Object>(commentVO, HttpStatus.ACCEPTED);
	}
}
