package com.smhrd.flutter.service;

import java.util.List;
import java.util.Optional;

import com.smhrd.flutter.model.Goods;

public interface GoodsServiceImpl {

	List<Goods> selectAllGoods();
	Optional<Goods> selectGoodsByGidx(Long gidx);
    List<Goods> selectGoodsByGidxRange(int start, int end); 
}
