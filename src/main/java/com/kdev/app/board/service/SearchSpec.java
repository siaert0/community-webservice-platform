package com.kdev.app.board.service;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.data.jpa.domain.Specification;

import com.kdev.app.board.domain.Board;

/**
 * <pre>
 * com.kdev.app.board.service
 * SearchSpec.java
 * </pre>
 * @author KDEV
 * @version 
 * @created 2017. 2. 8.
 * @updated 2017. 2. 8.
 * @history -
 * ==============================================
 *	검색 조건 이슈로 인하여 Specification 활용
 * ==============================================
 */
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
