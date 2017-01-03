package com.kdev.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.pk.BOARD_USER_CP_ID;
import com.kdev.app.domain.vo.Thumb;

public interface ThumbRepository extends JpaRepository<Thumb, BOARD_USER_CP_ID> {
	public List<Thumb> findByBoard(int board);
}
