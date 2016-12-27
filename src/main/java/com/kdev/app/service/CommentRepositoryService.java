package com.kdev.app.service;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.kdev.app.domain.CommentDTO;
import com.kdev.app.domain.CommentVO;
import com.kdev.app.domain.UserVO;
import com.kdev.app.exception.UserNotFoundException;
import com.kdev.app.repository.CommentRepository;

@Service
@Transactional
public class CommentRepositoryService {
	@Autowired
	private CommentRepository commentRepository;
	
	@Autowired
	ModelMapper modelMapper;
	
	public CommentVO create(CommentDTO.Create create){
		UserVO userVO = create.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Can't Found User");
		CommentVO created = commentRepository.save(modelMapper.map(create, CommentVO.class));
		
		if(created == null)
			throw new UserNotFoundException("Can't Found User");
		
		return created;
	}
	
	public CommentVO update(CommentVO update){
		return commentRepository.saveAndFlush(update);
	}
	
	public void delete(int id){
		commentRepository.delete(id);
	}
	
	public void deleteAll(int boardid){
		commentRepository.deleteByboardid(boardid);
	}
	
	public CommentVO findOne(int id){
		return commentRepository.findOne(id);
	}
	
	public Page<CommentVO> findAll(Pageable pageable, int board_id)
	{
		Page<CommentVO> page = commentRepository.findByboardid(pageable, board_id);
		return page;
	}
	
}
