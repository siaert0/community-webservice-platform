package com.kdev.app.domain.vo;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

import com.kdev.app.domain.pk.ScrapId;

import lombok.Data;

@Entity
@Table(name="scraps")
@Data
public class Scrap {
    @EmbeddedId
	private ScrapId scrapId;
    
    @Column(name = "BOARD_ID", insertable=false, updatable=false)
    private int board;
    
    @Column(name = "USER_ID", insertable=false, updatable=false)
    private String user;
}
