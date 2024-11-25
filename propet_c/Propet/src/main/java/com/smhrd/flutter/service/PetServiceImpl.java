package com.smhrd.flutter.service;

import java.util.List;

import com.smhrd.flutter.model.Pet;

public interface PetServiceImpl {
    public int petEnroll(Pet p);
    
    public List<Pet> selectAllPet(long uidx);
    
    public void deletePet(Long pidx);
    
    int updatePet(Long pidx, Pet updatedPet);
}
