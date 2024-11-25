package com.smhrd.flutter.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.smhrd.flutter.model.AiBoard;

@Repository
public interface BoardRepository extends JpaRepository<AiBoard, Long> {
	

}
