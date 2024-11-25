package com.smhrd.flutter.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import com.smhrd.flutter.model.Users;
// JpaRepository 상속시켜주기
@Repository
public interface MemberRepository extends JpaRepository<Users, Long>{
//	select * from Aimember where m_id =? and m_pw =?
//	find = select,  By = where 
//	순서대로 넣기
	public Users findByIdAndPw(String id, String pw);
	

}
