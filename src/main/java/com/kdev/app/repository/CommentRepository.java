package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.Comment;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
	public void deleteByboardid(int boardid);
	public Page<Comment> findByboardid(Pageable pageable, int boardid);
}
