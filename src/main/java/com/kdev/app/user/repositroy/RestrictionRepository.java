package com.kdev.app.user.repositroy;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.user.domain.PROVIDER_USER_CP_ID;
import com.kdev.app.user.domain.Restriction;

public interface RestrictionRepository extends JpaRepository<Restriction, PROVIDER_USER_CP_ID> {
	
}
