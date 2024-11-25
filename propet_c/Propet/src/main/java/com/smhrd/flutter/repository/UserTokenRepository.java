package com.smhrd.flutter.repository;

import com.smhrd.flutter.model.Pet;
import com.smhrd.flutter.model.UserToken;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserTokenRepository extends JpaRepository<UserToken, Long> {

	List<UserToken> findByUidx(long uidx);

	List<UserToken> findByTokenAndUidx(String token, long uidx);
}
