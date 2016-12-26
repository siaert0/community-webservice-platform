package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.BoardVO;
import com.kdev.app.domain.CommentVO;
import com.kdev.app.domain.UserVO;

public interface CommentRepository extends JpaRepository<CommentVO, Integer> {
	//public Page<CommentVO> findAllByBoardid(int boardid, Pageable pageable);
}
