package com.kdev.app.domain.vo;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.kdev.app.domain.pk.ScrapId;

import lombok.Data;

@Entity
@Table(name="scraps")
@Data
public class Scrap {
    @EmbeddedId
	private ScrapId scrapId;
    
    @ManyToOne
    @JoinColumn(name = "BOARD_ID", insertable=false, updatable=false)
    private Board board;
    
    @ManyToOne
    @JoinColumn(name = "USER_ID", insertable=false, updatable=false)
    private UserVO user;
}
