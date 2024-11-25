package com.smhrd.flutter.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

// Entity -> JPA(Class-Table 매핑)
@Entity(name="aimember")// 테이블 이름
@Getter
@Setter
public class AiMember {
	
	@Id // PK 지정 long 으로 자주 사용
	@GeneratedValue(strategy = GenerationType.IDENTITY) // 고유키 자동생성
	@Column(name ="uid")
	private long uid;
	
	@Column(name ="m_id")
	private String id;
	
	@Column(name ="m_pw")
	private String pw;
	
	@Column(name ="m_age")
	private int age;
	
	@Column(name ="m_nick")
	private String nick;
	
}
