package com.kdev.app.board.domain;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.data.jpa.domain.Specification;

public class SearchSpec {
	public static Specification<Board> containTitle(final String keyword){
		return new Specification<Board>() {

			@Override
			public Predicate toPredicate(Root<Board> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				// TODO Auto-generated method stub
				if(keyword == null)
					return null;
				return cb.like(root.get("title"), "%"+keyword+"%");
			}
			
		};
	}
	
	public static Specification<Board> containTags(final String keyword){
		return new Specification<Board>() {

			@Override
			public Predicate toPredicate(Root<Board> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				// TODO Auto-generated method stub
				if(keyword == null)
					return null;
				return cb.like(root.get("tags"), "%"+keyword+"%");
			}
			
		};
	}
	
	public static Specification<Board> category(final String keyword){
		return new Specification<Board>() {

			@Override
			public Predicate toPredicate(Root<Board> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				// TODO Auto-generated method stub
				if(keyword == null)
					return null;
				
				return cb.equal(root.get("category"), keyword);
			}
			
		};
	}
}
