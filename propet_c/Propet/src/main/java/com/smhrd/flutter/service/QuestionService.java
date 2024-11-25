package com.smhrd.flutter.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.flutter.model.Question;
import com.smhrd.flutter.repository.QuestionRepository;

@Service
public class QuestionService implements QuestionServiceImpl {

	@Autowired
	QuestionRepository repo;
	
	public List<Question> getQuestionList(long uidx, String qtf){
		return repo.findByUidxAndQtf(uidx, qtf);
	}
}
