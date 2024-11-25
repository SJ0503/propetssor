package com.smhrd.flutter.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smhrd.flutter.model.Question;
import com.smhrd.flutter.service.QuestionService;

@RestController
public class QuestionController {


	@Autowired
	QuestionService service;
	
	@PostMapping("/getQuestionList")
	public String getQuestionList(@RequestBody Map<String, String> request) {
		
		ObjectMapper om = new ObjectMapper();
		
		String uidxStr = request.get("uidx");
	    long uidx = Long.parseLong(uidxStr);
        String qtf = request.get("qtf");

        List<Question> qList = service.getQuestionList(uidx,qtf);
		
        String jsonString = null;
    	if (qList !=null) {
    		try {
    			jsonString = om.writeValueAsString(qList);
    		}catch (JsonProcessingException e) {
    			e.printStackTrace();
			}
    	}
    	
        return jsonString;
	}
}
