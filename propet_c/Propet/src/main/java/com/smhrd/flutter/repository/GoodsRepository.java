package com.smhrd.flutter.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.smhrd.flutter.model.Goods;


@Repository
public interface GoodsRepository extends JpaRepository<Goods, Long> {

	Optional<Goods> findById(long gidx);
	List<Goods> findByGidxBetween(int start, int end);
}
