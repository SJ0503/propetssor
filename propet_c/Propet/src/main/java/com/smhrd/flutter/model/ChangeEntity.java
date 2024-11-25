package com.smhrd.flutter.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "question_audit")
@Getter
@Setter
public class ChangeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "q_idx")
    private Long qidx;

    @Column(name = "q_tf")
    private String qtf;

    @Column(name = "q_content", columnDefinition = "TEXT")
    private String qcontent;

    @Column(name = "q_answer", columnDefinition = "TEXT")
    private String qanswer;

    @Column(name = "u_idx")
    private Long uidx;

    @Column(name = "changed_at")
    private LocalDateTime changedAt;

}
