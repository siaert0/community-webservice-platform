package com.kdev.app.board.service;

import static org.springframework.data.jpa.domain.Specifications.where;

import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Board;
import com.kdev.app.board.domain.Category;
import com.kdev.app.board.domain.Comment;
import com.kdev.app.board.domain.Scrap;
import com.kdev.app.board.domain.Thumb;
import com.kdev.app.board.exception.BoardNotFoundException;
import com.kdev.app.board.exception.NotCreatedException;
import com.kdev.app.board.repository.BoardRepository;
import com.kdev.app.board.repository.CategoryRepository;
import com.kdev.app.board.repository.CommentRepository;
import com.kdev.app.board.repository.ScrapRepository;
import com.kdev.app.board.repository.ThumbRepository;
import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.exception.UserNotFoundException;

@Service
@Transactional //@EnableTransactionManagement
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
	private CategoryRepository categoryRepository;
	
	@Autowired 
	private ModelMapper modelMapper;
	
	/**
	 * ===============================================================
	 * 		BoardRepository
	 * ===============================================================
	 */
	
	public Board createBoard(Board.Create createBoard){
		UserVO userVO = createBoard.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Can't Found User");
		
		Board createdBoard = boardRepository.save(modelMapper.map(createBoard, Board.class));
		
		if(createdBoard == null)
			throw new NotCreatedException();
			
		return createdBoard;
	}
	
	public Page<Board> findAllBoard(Pageable pageable){
		 return boardRepository.findAll(pageable);
	}
	/**
	 * #검색 및 페이징 기능 개선
	 * And Or연산을 중첩시키는 방법 : Specification
	 */
	public Page<Board> findAll(String search, String category, Pageable pageable){
		return boardRepository.findAll(where(SearchSpec.containTitle(search)).or(SearchSpec.containTags(search)).and(SearchSpec.category(category)), pageable);
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
			throw new BoardNotFoundException();
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
	
	public Comment createComment(Comment.Create create){
		UserVO userVO = create.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Not Founded User");
		
		Comment created = commentRepository.save(modelMapper.map(create, Comment.class));
		
		if(created == null)
			throw new NotCreatedException();
		
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
	
	public Page<Comment> findCommentAll(Pageable pageable){
		Page<Comment> page = commentRepository.findAll(pageable);
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
	
	/** 
	 *  ===============================================================
	 *  	CategoryRepository
	 *  ===============================================================
	 */
	
	public List<Category> findCategories(){
		return categoryRepository.findAll();
	}
	
	public Category addCategory(Category category){
		categoryRepository.save(category);
		return category;
	}
	
	public Category removeCategory(Category category){
		categoryRepository.delete(category);
		return category;
	}
}
