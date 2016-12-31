package com.kdev.app.service;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kdev.app.domain.Board;
import com.kdev.app.domain.BoardDTO;
import com.kdev.app.domain.UserVO;
import com.kdev.app.exception.NotCreatedException;
import com.kdev.app.exception.UserNotFoundException;
import com.kdev.app.repository.BoardRepository;
import com.kdev.app.repository.CommentRepository;

@Service
@Transactional
public class BoardRepositoryService {
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private CommentRepository commentRepository;
	
	@Autowired 
	ModelMapper modelMapper;
	
	public Board create(BoardDTO.Create createBoard){
		UserVO userVO = createBoard.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Can't Found User");
		
		Board createdBoard = boardRepository.save(modelMapper.map(createBoard, Board.class));
		
		if(createdBoard == null)
			throw new NotCreatedException("Board Not Created");
			
		return createdBoard;
	}
	
	public Page<Board> findByAll(Pageable pageable){
		 return boardRepository.findAll(pageable);
	}
	
	public Page<Board> findAllByCategory(String category, Pageable pageable){
		return boardRepository.findAllByCategory(category, pageable);
	}
	
	public Page<Board> findAllByUser(UserVO userVO, Pageable pageable){
		return boardRepository.findAllByUser(userVO, pageable);
	}
	
	public Board update(Board update){
		return boardRepository.saveAndFlush(update);
	}
	
	public void delete(int id){
		commentRepository.deleteByboardid(id);
		boardRepository.delete(id);
	}
	
	public Board findOne(int id){
		return boardRepository.findOne(id);
	}
}
