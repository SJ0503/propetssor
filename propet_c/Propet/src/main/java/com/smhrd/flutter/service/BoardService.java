package com.smhrd.flutter.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.flutter.model.AiBoard;
import com.smhrd.flutter.repository.BoardRepository;

@Service
public class BoardService implements BoardServiceImpl {

	@Autowired
	BoardRepository repo;
	
	@Override
	public List<AiBoard> boardList() {
		//select * from aiboard
		return repo.findAll();
	}

	@Override
	public int boardInsert(AiBoard b) {
		AiBoard result = repo.save(b);
		
		if(result!=null) return 1;
		else return 0;
	}

	@Override
	public String oneBoardImg(Long idx) {
		Optional<AiBoard> board = repo.findById(idx);
		
		if(board!=null) {
			String imgFileName = board.get().getImg();
//			1. File 객체 생성(위체서 가져온 파일 이름 활용) -> 그 파일 저장되어 있는 경로
			File targetFile = new File("c:\\img\\"+imgFileName);

//			2. base64 형식으로 인코딩 (File -> String)
			com.smhrd.flutter.coverter.ImageToBase64 converter = new com.smhrd.flutter.coverter.ImageToBase64();
			String fileStringValue= null;
			try {
				fileStringValue = converter.convert(targetFile);
			
			} catch (IOException e) {
				e.printStackTrace();
			}
			return fileStringValue;
		
		}else {
			return null;
		}
		
	}

}
