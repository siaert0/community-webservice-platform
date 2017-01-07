package com.kdev.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.pk.PROVIDER_USER_CP_ID;
import com.kdev.app.domain.vo.Restriction;

public interface RestrictionRepository extends JpaRepository<Restriction, PROVIDER_USER_CP_ID> {
	
}
