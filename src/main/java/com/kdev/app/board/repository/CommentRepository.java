package com.kdev.app.board.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.board.domain.Comment;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
	public void deleteByBoard(int boardid);
	public Page<Comment> findByBoard(Pageable pageable, int boardid);
	
}
