package com.smhrd.flutter.service;

import java.util.List;

import com.smhrd.flutter.model.AiBoard;

public interface BoardServiceImpl {
	
	// 전체 게시물 select
	public List<AiBoard> boardList();
	
//	게시물 추가 insert
	public int boardInsert(AiBoard b);
	
//	선택한 게시물 이미지
	public String oneBoardImg(Long idx);
}
