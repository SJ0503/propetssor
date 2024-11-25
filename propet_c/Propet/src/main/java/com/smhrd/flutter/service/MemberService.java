package com.smhrd.flutter.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.smhrd.flutter.model.Users;
import com.smhrd.flutter.repository.MemberRepository;

@Service
public class MemberService implements MemberServiceImpl {

	// MemberRepository 의존성 추가
	@Autowired
	MemberRepository repo;
	
	@Override
	public int memberJoin(Users m) {
		// insert / update 둘다
		// result : 어떤 값들이 insert 되었는지
		Users result =  repo.save(m);
		
		if(result!=null) return 1; // 가입성공
		else return 0; // 가입실패
	}

	public Users memberLogin(Users m) {
//		findAll->select*
//		findById -> pk가져오기
//		where 문findBy ?ANd?OR
		return  repo.findByIdAndPw(m.getId(), m.getPw());
	}
	
	@Override
	public Users memberUpdate(Users m) {
//		update
//		1. update(수정)하고 싶은 행 현재 정보 가져오기(select)
//		select -> primary key(uid) 조건
		Users member = repo.findById(m.getUidx()).orElseThrow(()->{
			throw new IllegalArgumentException("해당하는 uid가 없습니다"); //예외처리
		});
//		2. 수정하고 싶은 값으로 값 필드값 바꾸기(비밀번호, 닉네임)
		member.setPw(m.getPw());
		member.setUname(m.getUname());
		member.setUphone(m.getUphone());
		
//		3. member 가 가지고 있는 값으로 최종 저장 (save)
//		save -> insert(해당 uid 없을 때) / update(해당 uid 있을 때)
		Users result = repo.save(member);
		return result;
	}

	@Override
	public void memberDelete(long uidx) {
		repo.deleteById(uidx);
		
	}
		

}
