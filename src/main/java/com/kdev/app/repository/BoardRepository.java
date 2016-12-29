package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.BoardVO;
import com.kdev.app.domain.UserVO;

public interface BoardRepository extends JpaRepository<BoardVO, Integer> {
	public Page<BoardVO> findAllByUser(UserVO userVO, Pageable pageable);
	public Page<BoardVO> findAllByCategory(String category, Pageable pageable);
}
