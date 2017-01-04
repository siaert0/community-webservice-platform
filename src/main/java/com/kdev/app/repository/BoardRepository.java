package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.vo.Board;
import com.kdev.app.domain.vo.UserVO;

public interface BoardRepository extends JpaRepository<Board, Integer> {
	public void deleteByUser(UserVO userVO);
	public Page<Board> findAllByUser(UserVO userVO, Pageable pageable);
	public Page<Board> findAllByCategory(String category, Pageable pageable);
	public Page<Board> findAllByCategoryAndTitleContainingOrTagsContaining(String category, String title, String tags, Pageable pageable);
}
