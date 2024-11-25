package com.smhrd.flutter.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smhrd.flutter.model.Goods;
import com.smhrd.flutter.service.GoodsService;

@RestController
public class GoodsController {

    @Autowired
    GoodsService service;

    @GetMapping("/selectAllGoods")
    public String selectAllGoods(@RequestParam(required = false) Long gidx) {
        List<Goods> list;
        if (gidx != null) {
        	Optional<Goods> optionalGoods = service.selectGoodsByGidx(gidx);
            list = optionalGoods.map(List::of).orElseGet(List::of);
        } else {
            list = service.selectAllGoods();
        }

        ObjectMapper om = new ObjectMapper();
        String jsonString = null;
        if (list != null) {
            try {
                jsonString = om.writeValueAsString(list);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }
        return jsonString;
    }
    
    @GetMapping("/selectGoodsByCategory")
    public String selectGoodsByCategory(@RequestParam String category) {
        List<Goods> list;
        switch (category) {
            case "종합영양제":
                list = service.selectGoodsByGidxRange(1, 2);
                break;
            case "장/유산균":
                list = service.selectGoodsByGidxRange(3, 4);
                break;
            case "피부/모질":
                list = service.selectGoodsByGidxRange(5, 6);
                break;
            default:
                list = service.selectAllGoods();
                break;
        }

        ObjectMapper om = new ObjectMapper();
        String jsonString = null;
        if (list != null) {
            try {
                jsonString = om.writeValueAsString(list);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }
        return jsonString;
    }
}
