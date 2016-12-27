package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.CommentVO;

public interface CommentRepository extends JpaRepository<CommentVO, Integer> {
	public void deleteByboardid(int boardid);
	public Page<CommentVO> findByboardid(Pageable pageable, int boardid);
}
