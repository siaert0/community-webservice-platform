package com.kdev.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.pk.ScrapId;
import com.kdev.app.domain.vo.Scrap;
import com.kdev.app.domain.vo.UserVO;

public interface ScrapRepository extends JpaRepository<Scrap, ScrapId> {
	public Page<Scrap> findByUser(UserVO user, Pageable pageable);
}
