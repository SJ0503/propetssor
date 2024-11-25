package com.smhrd.flutter.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smhrd.flutter.model.ChangeEntity;
import com.smhrd.flutter.model.Pet;
import com.smhrd.flutter.model.UserToken;
import com.smhrd.flutter.repository.ChangeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.HashMap;
import java.util.List;

@Service
public class PollingService {

    @Autowired
    private ChangeRepository changeRepository;

    @Autowired
    private FCMService fcmService;
    
    @Autowired
    private UserTokenService tokenService;

    @Scheduled(fixedRate = 5000) // 1분 간격으로 폴링
    public void pollDatabaseForChanges() {
        System.out.println("Polling database for changes...");
        List<ChangeEntity> changes = changeRepository.findAll();
        for (ChangeEntity change : changes) {
            // 여기서 알림 전송 로직 추가
            List<UserToken> tokens = selectToken(change.getUidx());
            System.out.println("-----------------------------");
            System.out.println(tokens);
            for (UserToken token : tokens) {
                System.out.println("Token: " + token.getToken() + ", UIdx: " + change.getUidx());
                fcmService.sendNotification(token.getToken(), 
                		"미응답 답변이 등록되었습니다.", 
                		change.getQcontent() + "에 대한 답변이 등록되었습니다.");
                System.out.println("--------------------- 답변 전송 완료");
            }
        }
        // 변경 사항 처리 후 테이블 비우기 (또는 처리된 항목만 삭제)
        changeRepository.deleteAll(changes);
    }
    
    public List<UserToken> selectToken(Long uidx) {
    	ObjectMapper om = new ObjectMapper();
    	List<UserToken> list = tokenService.selectToken(uidx);
    	
    	return list;
    }
    
}
