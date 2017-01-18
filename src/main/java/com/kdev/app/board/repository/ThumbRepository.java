package com.kdev.app.board.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.board.domain.BOARD_USER_CP_ID;
import com.kdev.app.board.domain.Thumb;

public interface ThumbRepository extends JpaRepository<Thumb, BOARD_USER_CP_ID> {
	public List<Thumb> findByBoard(int board);
}
