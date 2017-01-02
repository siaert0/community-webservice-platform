package com.kdev.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.vo.UserVO;

public interface UserRepository extends JpaRepository<UserVO, String> {
	public UserVO findByEmail(String email);
}
