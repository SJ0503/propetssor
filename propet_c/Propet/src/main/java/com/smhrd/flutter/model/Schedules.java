package com.smhrd.flutter.model;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.sql.Date;  // 수정된 부분
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;

@Entity(name="schedules")
@Getter
@Setter
public class Schedules {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "s_idx")
    private Long sidx;

    @Column(name = "start_time", nullable = false)
    private String startTime;

    @Column(name = "end_time", nullable = false)
    private String endTime;

    @Column(name = "s_content", length = 255)
    private String content;

    @Column(name = "s_date", nullable = false, updatable = false)
    private Timestamp sdate;

    @Column(name = "ndate", nullable = false)
    private Date ndate;  // 수정된 부분
    
    @Column(name ="u_idx")
    private long uidx;

    @PrePersist
    protected void onCreate() {
        if (sdate == null) {
            sdate = new Timestamp(System.currentTimeMillis());
        }
    }
}
