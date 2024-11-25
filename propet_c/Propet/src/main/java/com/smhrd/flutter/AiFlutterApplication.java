package com.smhrd.flutter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class AiFlutterApplication {

    public static void main(String[] args) {
        SpringApplication.run(AiFlutterApplication.class, args);
    }
}
