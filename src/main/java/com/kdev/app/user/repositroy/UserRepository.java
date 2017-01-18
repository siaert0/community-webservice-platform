package com.kdev.app.user.repositroy;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.enums.SocialProvider;

public interface UserRepository extends JpaRepository<UserVO, String> {
	public UserVO findByEmail(String email);
	public List<UserVO> findBySocialProvider(SocialProvider socialProvider);
}
