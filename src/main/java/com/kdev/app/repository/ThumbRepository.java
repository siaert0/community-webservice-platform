package com.kdev.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.pk.ThumbId;
import com.kdev.app.domain.vo.Thumb;

public interface ThumbRepository extends JpaRepository<Thumb, ThumbId> {

}
