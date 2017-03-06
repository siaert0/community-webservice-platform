package com.kdev.app.board.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import com.kdev.app.board.domain.Comment;
import com.kdev.app.user.domain.UserVO;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
	public void deleteByBoard(int boardid);
	public void deleteByUser(@Param("user") UserVO userVO);
	public Page<Comment> findByBoard(Pageable pageable, int boardid);
}
