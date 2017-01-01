package com.kdev.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.domain.pk.ScrapId;
import com.kdev.app.domain.vo.Scrap;

public interface ScrapRepository extends JpaRepository<Scrap, ScrapId> {

}
