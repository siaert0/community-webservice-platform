package com.kdev.app.controller;

import java.security.Principal;
import java.util.List;

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
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kdev.app.domain.Board;
import com.kdev.app.domain.BoardDTO;
import com.kdev.app.domain.UserVO;
import com.kdev.app.exception.ExceptionResponse;
import com.kdev.app.exception.NotFoundException;
import com.kdev.app.exception.ValidException;
import com.kdev.app.service.BoardRepositoryService;
import com.kdev.app.service.UserRepositoryService;

@Controller
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private BoardRepositoryService boardRepositoryService;
	
	@Autowired
	private UserRepositoryService userRepositroyService;
	
	@Autowired 
	ModelMapper modelMapper;
	
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/board", method=RequestMethod.GET)
	public String board_form(Model model){
		return "board/form";
	}
	
	@RequestMapping(value="/board/{id}", method=RequestMethod.GET)
	public String findBoardOne(@PathVariable int id, Model model){
		Board boardVO = boardRepositoryService.findOne(id);	
		if(boardVO == null)
			throw new NotFoundException("게시물을 찾을 수 없습니다.");
		model.addAttribute("content", boardVO);
		return "board/detail";
	}
	
	@RequestMapping(value="/board/{id}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoardOneREST(@PathVariable int id){
		
		Board boardVO = boardRepositoryService.findOne(id);
		
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
	public ResponseEntity<Object> createBoard(@RequestBody @Valid BoardDTO.Create createBoard, BindingResult result, Principal principal){
		
		if(result.hasErrors()){
			throw new ValidException();
		}
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		createBoard.setUser(userVO);
		Board createdBoard = boardRepositoryService.create(createBoard);
		return new ResponseEntity<Object>(createdBoard, HttpStatus.CREATED);
	}
		
	/**
	 * @author		: K
	 * @method		: findBoard
	 * @description	: 게시물 가져오기 & 페이징
	 */
	@RequestMapping(value="/board", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoard(@RequestParam(value="category", required=false, defaultValue="") String category, @PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 5) Pageable pageable){
		Page<Board> page = null;
		
		if(category.equals(""))
			page= boardRepositoryService.findByAll(pageable);
		else
			page = boardRepositoryService.findAllByCategory(category, pageable);
		return new ResponseEntity<Object>(page, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: findBoardByUser
	 * @description	: 사용자가 작성한 게시물 가져오기 & 페이징
	 */
	@RequestMapping(value="/board/me/{userid}", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> findBoardByUser(@PathVariable String userid,@PageableDefault(sort = { "id" }, direction = Direction.DESC, size = 1000) Pageable pageable){
		Page<Board> page = boardRepositoryService.findAllByUser(userRepositroyService.findUserById(userid), pageable);
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
	public ResponseEntity<Object> updateBoard(@PathVariable int id, @RequestBody BoardDTO.Update update, Principal principal){
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		Board boardVO = boardRepositoryService.findOne(id);
		
		if(!(boardVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(update, HttpStatus.FORBIDDEN);
		
		boardVO.setCategory(update.getCategory());
		boardVO.setDescription(update.getDescription());
		boardVO.setTitle(update.getTitle());
		boardVO.setTags(update.getTags());
		boardVO.setSelected(update.getSelected());

		Board updated = boardRepositoryService.update(boardVO);
		return new ResponseEntity<Object>(updated, HttpStatus.ACCEPTED);
	}
	
	/**
	 * @author		: K
	 * @method		: deleteBoard
	 * @description	: 게시물 삭제
	 */
	@Secured(value="ROLE_USER")
	@RequestMapping(value="/board/{id}", method=RequestMethod.DELETE, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> deleteBoard(@PathVariable int id, Principal principal){
		
		UserVO userVO = userRepositroyService.findUserByEmail(principal.getName());
		Board boardVO = boardRepositoryService.findOne(id);
		
		if(!(boardVO.getUser().getId().equals(userVO.getId())))
			return new ResponseEntity<Object>(boardVO, HttpStatus.FORBIDDEN);
		
		boardRepositoryService.delete(id);
		return new ResponseEntity<Object>(boardVO, HttpStatus.ACCEPTED);
		
	}
}
