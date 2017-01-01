package com.kdev.app.domain.vo;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.kdev.app.domain.pk.ThumbId;

import lombok.Data;

@Entity
@Table(name = "thumbs")
@Data
public class Thumb {
    @EmbeddedId
	private ThumbId thumbId;
    
    @Column(name = "BOARD_ID", insertable=false, updatable=false)
    private int board;
    
    @Column(name = "USER_ID", insertable=false, updatable=false)
    private String user;
}
