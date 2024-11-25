package com.smhrd.flutter.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity(name="aiboard")
@Getter
@Setter
public class AiBoard {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="idx")
	private Long idx;
	
	@Column(name = "b_title")
	private String title;
	
	@Column(name = "b_content", length = 2000)
	private String content;
	
	@Column(name = "b_writer")
	private String writer;
	
	@Column(name = "b_img")
	private String img; // 임이지 파일 이름
	
}
