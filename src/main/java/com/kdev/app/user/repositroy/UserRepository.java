package com.kdev.app.user.repositroy;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.kdev.app.user.domain.UserVO;
import com.kdev.app.user.enums.SocialProvider;

@RepositoryRestResource(collectionResourceRel = "users", path = "users")
public interface UserRepository extends JpaRepository<UserVO, String> {
	public UserVO findByEmail(@Param("email") String email);
	public List<UserVO> findBySocialProvider(@Param("socialProvider") SocialProvider socialProvider);
}
