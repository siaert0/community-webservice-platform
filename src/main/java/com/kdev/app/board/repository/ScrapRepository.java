package com.kdev.app.board.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Scrap;
import com.kdev.app.user.domain.UserVO;

@RepositoryRestResource(exported=false)
public interface ScrapRepository extends JpaRepository<Scrap, BOARD_USER_CP_ID> {
	public Page<Scrap> findByUser(UserVO user, Pageable pageable);
}
