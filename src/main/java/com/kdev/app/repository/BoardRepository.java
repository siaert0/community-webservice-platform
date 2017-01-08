package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.kdev.app.domain.vo.Board;
import com.kdev.app.domain.vo.UserVO;

public interface BoardRepository extends JpaRepository<Board, Integer>, JpaSpecificationExecutor<Board> {
	public void deleteByUser(UserVO userVO);
	public Page<Board> findAllByUser(UserVO userVO, Pageable pageable);
	public Page<Board> findAllByCategory(String category, Pageable pageable);
	
	/**
	 * # And Or 연산 오류로 인해 JpaSpecification으로 대체함
	 * 기존 where title like = ? or tags like = ? and category = ?
	 * Specification 적용 후 where (title like = ? or tags like = 2 ) and category = ?
	 */
	//public Page<Board> findByTitleOrTagsContainingAndCategory(String title, String tags, String category, Pageable pageable);
}
