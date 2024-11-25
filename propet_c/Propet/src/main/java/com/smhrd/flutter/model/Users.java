package com.smhrd.flutter.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity(name="users") //테이블이름
@Getter
@Setter
public class Users {

	
	@Id // PK 지정 long 으로 자주 사용
	@GeneratedValue(strategy = GenerationType.IDENTITY) // 고유키 자동생성
	@Column(name ="u_idx")
	private long uidx;
	
	@Column(name ="u_id", length = 50)
	private String id;
	
	@Column(name ="u_name", length = 50)
	private String uname;
	
	@Column(name ="u_pw", length = 50)
	private String pw;               
	
	@Column(name ="u_phone", length = 50)
	private String uphone;
	
	//등록일 필요하나?
	

}
