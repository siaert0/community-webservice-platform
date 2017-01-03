package com.kdev.app.domain.vo;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.kdev.app.domain.pk.BOARD_USER_CP_ID;

import lombok.Data;

@Entity
@Table(name = "THUMBS")
@Data
public class Thumb {
    @EmbeddedId
	private BOARD_USER_CP_ID BOARD_USER_CP_ID;
    
    @Column(name = "BD_ID", insertable=false, updatable=false)
    private int board;
    
    @ManyToOne
    @JoinColumn(name = "USER_ID", insertable=false, updatable=false)
    private UserVO user;
}
