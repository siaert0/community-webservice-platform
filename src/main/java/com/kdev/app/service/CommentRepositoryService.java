package com.kdev.app.service;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.kdev.app.domain.Comment;
import com.kdev.app.domain.CommentDTO;
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
	
	public Comment create(CommentDTO.Create create){
		UserVO userVO = create.getUser();
		if(userVO == null)
			throw new UserNotFoundException("Can't Found User");
		Comment created = commentRepository.save(modelMapper.map(create, Comment.class));
		
		if(created == null)
			throw new UserNotFoundException("Can't Found User");
		
		return created;
	}
	
	public Comment update(Comment update){
		return commentRepository.saveAndFlush(update);
	}
	
	public void delete(int id){
		commentRepository.delete(id);
	}
	
	public void deleteAll(int boardid){
		commentRepository.deleteByboardid(boardid);
	}
	
	public Comment findOne(int id){
		return commentRepository.findOne(id);
	}
	
	public Page<Comment> findAll(Pageable pageable, int board_id)
	{
		Page<Comment> page = commentRepository.findByboardid(pageable, board_id);
		return page;
	}
	
}
