package com.smhrd.flutter.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity(name="usertoken")
@Getter
@Setter
public class UserToken {

	@Id // PK 지정 long 으로 자주 사용
	@GeneratedValue(strategy = GenerationType.IDENTITY) // 고유키 자동생성
	@Column(name ="t_idx")
	private long tidx;
	
	@Column(name ="token", length = 255)
	private String token;
	
	@Column(name ="u_idx")
	private long uidx;
}
