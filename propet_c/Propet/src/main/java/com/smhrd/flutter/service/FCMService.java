package com.smhrd.flutter.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import org.springframework.stereotype.Service;

@Service
public class FCMService {

    public void sendNotification(String token, String title, String body) {
    	
    	System.out.println(title);
    	System.out.println(body);
    	
    	
        Message message = Message.builder()
                .setToken(token)
                .putData("미음답 답변이 등록되었습니다", title)
                .putData("body", body)
                .build();

        try {
            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message: " + response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
