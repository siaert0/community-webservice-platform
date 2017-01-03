package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.kdev.app.domain.pk.BOARD_USER_CP_ID;
import com.kdev.app.domain.vo.Scrap;
import com.kdev.app.domain.vo.UserVO;

public interface ScrapRepository extends JpaRepository<Scrap, BOARD_USER_CP_ID> {
	public Page<Scrap> findByUser(UserVO user, Pageable pageable);
}
