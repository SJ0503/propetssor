package com.smhrd.flutter.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.io.InputStream;

@Configuration
public class FirebaseInitializer {

    @Bean
    public FirebaseApp initializeFirebaseApp() {
        try {
            // Load service account file directly
            ClassPathResource serviceAccountResource = new ClassPathResource("firebase-service-account.json");
            InputStream serviceAccountStream = serviceAccountResource.getInputStream();

            // Initialize Firebase Options
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccountStream))
                    .build();

            // Close the stream after initializing Firebase
            serviceAccountStream.close();

            return FirebaseApp.initializeApp(options);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize Firebase", e);
        }
    }
}
