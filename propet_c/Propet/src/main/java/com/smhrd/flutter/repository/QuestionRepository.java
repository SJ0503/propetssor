package com.smhrd.flutter.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.smhrd.flutter.model.Question;

@Repository
public interface QuestionRepository extends JpaRepository<Question, Long>  {

	List<Question> findByUidxAndQtf(long uidx, String qtf);

}
