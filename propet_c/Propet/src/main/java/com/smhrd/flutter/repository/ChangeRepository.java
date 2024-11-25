package com.smhrd.flutter.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.smhrd.flutter.model.ChangeEntity;

@Repository
public interface ChangeRepository extends JpaRepository<ChangeEntity, Long>{

}
