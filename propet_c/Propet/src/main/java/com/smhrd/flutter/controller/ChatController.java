package com.smhrd.flutter.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.smhrd.flutter.service.ChatService;

import java.util.Map;

@RestController
public class ChatController {

	@Autowired
    private ChatService chatService;

	@PostMapping("/chat")
    public ResponseEntity<String> chatWithFlask(@RequestBody Map<String, String> requestData) {
        System.out.println(requestData);
        String response = chatService.processRequest(requestData);
        System.out.println(response);
        return ResponseEntity.ok(response);
    }
}