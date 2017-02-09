package com.kdev.app.board.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RestResource;

import com.kdev.app.board.domain.Board;
import com.kdev.app.user.domain.UserVO;


public interface BoardRepository extends JpaRepository<Board, Integer>, JpaSpecificationExecutor<Board> {
	@RestResource(exported=false) // REST Prevent
	public void deleteByUser(@Param("user") UserVO userVO);
	public Page<Board> findAllByUser(@Param("user") UserVO userVO, Pageable pageable);
	public Page<Board> findAllByCategory(@Param("category") String category, Pageable pageable);
	/**
	 * # And Or 연산 오류로 인해 JpaSpecification으로 대체함
	 * 기존 where title like = ? or tags like = ? and category = ?
	 * Specification 적용 후 where (title like = ? or tags like = 2 ) and category = ?
	 */
	//public Page<Board> findByTitleOrTagsContainingAndCategory(String title, String tags, String category, Pageable pageable);
}
