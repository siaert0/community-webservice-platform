package com.kdev.app.board.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kdev.app.board.domain.Category;


public interface CategoryRepository extends JpaRepository<Category, String> {

}
