package com.kdev.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.enums.SocialProvider;

public interface UserRepository extends JpaRepository<UserVO, String> {
	public UserVO findByEmail(String email);
	public List<UserVO> findBySocialProvider(SocialProvider socialProvider);
}
