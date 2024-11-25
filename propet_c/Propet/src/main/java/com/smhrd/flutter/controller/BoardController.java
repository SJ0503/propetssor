package com.smhrd.flutter.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smhrd.flutter.model.AiBoard;
import com.smhrd.flutter.service.BoardService;

@RestController
public class BoardController {

	@Autowired
	BoardService service;

	// http://host:8089/boot/board/list
	@GetMapping("/board/list")
	public String boardList() { // 게시물 전체 데이터 응답

		List<AiBoard> list = service.boardList();

		ObjectMapper om = new ObjectMapper();
		String jsonString = null;

		if (list != null) {
			try {
				jsonString = om.writeValueAsString(list);
			} catch (JsonProcessingException e) {
				e.printStackTrace();
			}
		}
		return jsonString;
	}



//RequestBody => json/xml 데이터를 받을 때
//multipart/form-data => RequestParam(title, content, writer)
//					=> RequestPart(files)

@PostMapping("/board/insert")
public int boardInsert(@RequestParam("title") String title,
			@RequestParam("content") String content, @RequestParam("writer") String writer,
			@RequestPart("files") List<MultipartFile> files) throws IllegalStateException, IOException {
		
	System.out.println(title);
		System.out.println(content);
		System.out.println(writer);
		System.out.println(files.size());
		
		AiBoard insertBoard = new AiBoard();
		insertBoard.setTitle(title);
		insertBoard.setContent(content);
		insertBoard.setWriter(writer);
		
//		파일저장(지정한 경로), 파일의 이름만 DB에 저장
//		랜덤문자열(UUID) + 파일 이름
		for(MultipartFile f :files) {
			// 1. 파일 이름 랜덤 생성
			String fName = UUID.randomUUID().toString() + f.getOriginalFilename();
//			 2. 파일 저장
			f.transferTo(new File(fName));
//			throws IllegalStateException, IOException 특수문자 예외처리
//			3. 파일이름이 db에 저장
			insertBoard.setImg(fName);
//			++여러개의 파일 이름을 저장하고 싶은경우
//			1) ~~,~~/ 형식으로 문자열을 만든 다음에 for 문 바깥쪾에서 한번만 setImg() 호출
//			2) 컬럼을 여러개 (최대 추가할 수 있는 이미지의 개수 제한)
		}
		return service.boardInsert(insertBoard);
//		return 0;
}
		@GetMapping("/board")
		public String oneBoardImg(@RequestBody HashMap<String, Object>map) {
			System.out.println(map);
			ObjectMapper om = new ObjectMapper();
			Long idx = om.convertValue(map.get("idx"), Long.class);
			String result = service.oneBoardImg(idx);
			
			System.out.println(result);
			
			return result;
}

}