package com.kdev.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.kdev.app.domain.Code;
import com.kdev.app.enums.CodeType;

public interface CodeRepository extends JpaRepository<Code, Integer> {
	
	@Query("select c from Code c where c.parent = null")
	public List<Code> findByParentNull();
	
	@Query("select c from Code c where c.parent = null and c.code =:code")
	public List<Code> findByParentNullType(@Param("code") Code code);
}
