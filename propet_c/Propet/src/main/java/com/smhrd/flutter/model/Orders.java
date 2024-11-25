package com.smhrd.flutter.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity(name="orders")
@Getter
@Setter
public class Orders {

	@Id // PK 지정 long 으로 자주 사용
	@GeneratedValue(strategy = GenerationType.IDENTITY) // 고유키 자동생성
	@Column(name = "o_idx")
	private long oidx;
	
	@Column(name ="o_cost") //주문총가격
	private long ocost;
	
	@Column(name ="o_state", length = 50) //주문 상태
	private String ostate;
	
	
	@Column(name ="u_idx")
	private long uidx;
	
}
