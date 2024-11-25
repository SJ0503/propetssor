package com.smhrd.flutter.controller;

import com.smhrd.flutter.model.UserToken;
import com.smhrd.flutter.repository.UserTokenRepository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class FCMTokenController {

    @Autowired
    private UserTokenRepository userTokenRepository;

    // 클라이언트에서 전송한 FCM 토큰을 저장합니다.
    @PostMapping("/token")
    public void saveToken(@RequestBody UserToken userToken) {
        // 이미 존재하는 레코드인지 확인
    	
    	
        List<UserToken> existingRecord = userTokenRepository.findByTokenAndUidx(userToken.getToken(), userToken.getUidx());
        
        if (existingRecord != null) {
            // 이미 존재하는 레코드인 경우 저장하지 않음
            System.out.println("Record already exists for token: " + userToken.getToken() + " and uidx: " + userToken.getUidx());
        } else {
            // 새로운 레코드를 저장
            userTokenRepository.save(userToken);
            System.out.println("Saved new record for token: " + userToken.getToken() + " and uidx: " + userToken.getUidx());
        }
    }

    
    
}
