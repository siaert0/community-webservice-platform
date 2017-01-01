package com.kdev.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.pk.ThumbId;
import com.kdev.app.domain.vo.Thumb;

public interface ThumbRepository extends JpaRepository<Thumb, ThumbId> {
	public List<Thumb> findByBoard(int board);
}
