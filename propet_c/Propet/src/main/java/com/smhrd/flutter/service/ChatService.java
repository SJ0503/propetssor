package com.smhrd.flutter.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class ChatService {

    // Flask 서버의 URL 설정
    private String flaskServerUrl = "http://192.168.219.48:5001";

    private final RestTemplate restTemplate;

    // RestTemplate 객체를 주입받아서 초기화
    public ChatService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * 클라이언트 요청을 Flask 서버로 전송하고, 응답을 받아오는 메서드
     * @param requestData 클라이언트에서 전달된 요청 데이터
     * @return Flask 서버로부터 받은 응답 데이터
     */
    public String processRequest(Map<String, String> requestData) {
        // HTTP 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");
        headers.set("Connection", "keep-alive");

        // HTTP 요청 본문 설정
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(requestData, headers);

        // POST 방식으로 Flask 서버에 요청을 보내고, ResponseEntity로 응답을 받음
        ResponseEntity<String> responseEntity = restTemplate.exchange(
                flaskServerUrl + "/chat",  // Flask 서버의 chat 엔드포인트에 POST 요청
                HttpMethod.POST,
                requestEntity,
                String.class  // 응답 데이터 타입은 String으로 설정
        );

        // 받은 응답 데이터를 반환
        return responseEntity.getBody();
    }
}
