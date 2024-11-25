package com.smhrd.flutter.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.flutter.model.UserToken;
import com.smhrd.flutter.repository.UserTokenRepository;

@Service
public class UserTokenService implements UserTokenServiceImpl{

	@Autowired
	UserTokenRepository repo;
	
	public List<UserToken> selectToken(long uidx){
		return repo.findByUidx(uidx);
	}
	
	
}
