package com.kdev.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kdev.app.domain.pk.ThumbId;
import com.kdev.app.domain.vo.Thumb;
import com.kdev.app.repository.ThumbRepository;

@Service
public class ThumbRepositoryService {
	@Autowired
	ThumbRepository thumbRepository;
	
	public Thumb checkThumb(ThumbId thumbId){
		Thumb thumb = null;
		if(thumbRepository.findOne(thumbId) == null){
			thumb = new Thumb();
			thumb.setThumbId(thumbId);
			thumb = thumbRepository.save(thumb);
		}else
			thumbRepository.delete(thumbId);
		
		return thumb;
	}
	
	public List<Thumb> findByBoard(int board){
		return thumbRepository.findByBoard(board);
	}
}
