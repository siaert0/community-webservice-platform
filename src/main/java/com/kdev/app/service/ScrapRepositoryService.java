package com.kdev.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.kdev.app.domain.pk.ScrapId;
import com.kdev.app.domain.vo.Scrap;
import com.kdev.app.domain.vo.UserVO;
import com.kdev.app.repository.ScrapRepository;

@Service
public class ScrapRepositoryService {
	@Autowired
	ScrapRepository scrapRepository;
	
	public Scrap checkScrap(ScrapId scrapId){
		Scrap scrap = new Scrap();
			scrap.setScrapId(scrapId);
			scrap = scrapRepository.save(scrap);
		return scrap;
	}
	
	public void deleteScrap(ScrapId scrapId){
		scrapRepository.delete(scrapId);
	}
	
	public Page<Scrap> findByUser(UserVO user, Pageable pageable){
		return scrapRepository.findByUser(user, pageable);
	}
}
