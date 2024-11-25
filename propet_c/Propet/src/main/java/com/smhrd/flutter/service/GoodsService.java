package com.smhrd.flutter.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.smhrd.flutter.model.Goods;
import com.smhrd.flutter.repository.GoodsRepository;


@Service
public class GoodsService implements GoodsServiceImpl {

	@Autowired
    GoodsRepository repo;
	
	@Override
    public List<Goods> selectAllGoods() {
        return repo.findAll();
    }

    @Override
    public Optional<Goods> selectGoodsByGidx(Long gidx) {
        return repo.findById(gidx);
    }
    
    @Override
    public List<Goods> selectGoodsByGidxRange(int start, int end) {
        return repo.findByGidxBetween(start, end);
    }

}
