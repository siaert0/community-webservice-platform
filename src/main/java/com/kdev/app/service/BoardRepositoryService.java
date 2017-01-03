package com.kdev.app.service;

import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kdev.app.domain.dto.BoardDTO;
import com.kdev.app.domain.dto.CommentDTO;
import com.kdev.app.domain.pk.BOARD_USER_CP_ID;
import com.kdev.app.domain.vo.Board;
import com.kdev.app.domain.vo.Comment;
import com.kdev.app.domain.vo.Scrap;
import com.kdev.app.domain.vo.Thumb;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.exception.NotCreatedException;
import com.kdev.app.exception.NotFoundException;
import com.kdev.app.exception.UserNotFoundException;
import com.kdev.app.repository.BoardRepository;
import com.kdev.app.repository.CommentRepository;
import com.kdev.app.repository.ScrapRepository;
import com.kdev.app.repository.ThumbRepository;

@Service
@Transactional
public class BoardRepositoryService {
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private CommentRepository commentRepository;
	
	@Autowired
	private ScrapRepository scrapRepository;
	
	@Autowired
	private ThumbRepository thumbRepository;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	/**
	 * ===============================================================
	 * 		BoardRepository
	 * ===============================================================
	 */
	
	public Board createBoard(BoardDTO.Create createBoard){
		UserVO userVO = createBoard.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Can't Found User");
		
		Board createdBoard = boardRepository.save(modelMapper.map(createBoard, Board.class));
		
		if(createdBoard == null)
			throw new NotCreatedException("Board Not Created");
			
		return createdBoard;
	}
	
	public Page<Board> findAllBoard(Pageable pageable){
		 return boardRepository.findAll(pageable);
	}
	
	public Page<Board> findAllBoardByCategory(String category, Pageable pageable){
		return boardRepository.findAllByCategory(category, pageable);
	}
	
	public Page<Board> findAllBoardByUser(UserVO userVO, Pageable pageable){
		return boardRepository.findAllByUser(userVO, pageable);
	}
	
	public Board updateBoard(Board update){
		return boardRepository.saveAndFlush(update);
	}
	
	public void deleteBoard(int id){
		boardRepository.delete(id);
	}
	
	public Board findBoardOne(int id){
		Board board = boardRepository.findOne(id);
		if(board == null)
			throw new NotFoundException("Board Not Exist");
		return board;
	}
	public void deleteBoardAllByUser(UserVO userVO){
		boardRepository.deleteByUser(userVO);
	}
	
	/**
	 * ===============================================================
	 * 		CommentRepository
	 * ===============================================================
	 */
	
	public Comment createComment(CommentDTO.Create create){
		UserVO userVO = create.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Not Founded User");
		
		Comment created = commentRepository.save(modelMapper.map(create, Comment.class));
		
		if(created == null)
			throw new NotCreatedException("Failed Create Comment");
		
		return created;
	}
	
	public Comment updateComment(Comment update){
		return commentRepository.saveAndFlush(update);
	}
	
	public void deleteComment(int id){
		commentRepository.delete(id);
	}
	
	public void deleteCommentAll(int boardid){
		commentRepository.deleteByBoard(boardid);
	}
	
	public Comment findCommentOne(int id){
		return commentRepository.findOne(id);
	}
	
	public Page<Comment> findCommentAll(Pageable pageable, int board_id)
	{
		Page<Comment> page = commentRepository.findByBoard(pageable, board_id);
		return page;
	}
	
	/** 
	 *  ===============================================================
	 *  	ThumbRepository
	 *  ===============================================================
	 */ 
	
	public Thumb checkThumb(BOARD_USER_CP_ID BOARD_USER_CP_ID){
		Thumb thumb = thumbRepository.findOne(BOARD_USER_CP_ID);
		
		if(thumb == null){
			thumb = new Thumb();
			thumb.setBOARD_USER_CP_ID(BOARD_USER_CP_ID);
			thumb = thumbRepository.save(thumb);
		}else
			thumbRepository.delete(BOARD_USER_CP_ID);
		
		return thumb;
	}
	
	public List<Thumb> findThumbByBoard(int board){
		return thumbRepository.findByBoard(board);
	}
	
	/** 
	 *  ===============================================================
	 *  	ScrapRepository
	 *  ===============================================================
	 */ 
	
	public Scrap checkScrap(BOARD_USER_CP_ID BOARD_USER_CP_ID){
		Scrap scrap = new Scrap();
			  scrap.setBOARD_USER_CP_ID(BOARD_USER_CP_ID);
		return scrapRepository.save(scrap);
	}
	
	public void deleteScrap(BOARD_USER_CP_ID BOARD_USER_CP_ID){
		scrapRepository.delete(BOARD_USER_CP_ID);
	}
	
	public Page<Scrap> findScrapByUser(UserVO user, Pageable pageable){
		return scrapRepository.findByUser(user, pageable);
	}
}
