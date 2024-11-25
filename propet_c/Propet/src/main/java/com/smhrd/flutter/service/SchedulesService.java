package com.smhrd.flutter.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.smhrd.flutter.model.Schedules;
import com.smhrd.flutter.repository.SchedulesRepository;

import java.sql.Date;
import java.util.List;

@Service
public class SchedulesService implements SchedulesServiceImpl {

    @Autowired
    private SchedulesRepository repo;

    @Override
    public Schedules createSchedule(Schedules schedule) {
        return repo.save(schedule);
    }

    @Override
    public List<Schedules> getAllSchedules() {
        return repo.findAll();
    }

    @Override
    public Schedules getScheduleById(Long sidx) {
        return repo.findById(sidx).orElse(null);
    }

    @Override
    public void deleteSchedule(Long sidx) {
    	repo.deleteById(sidx);
    }
    
    @Override
    public List<Schedules> getSchedulesByUserId(Long uidx) {
        return repo.findByUidx(uidx);
    }
    
    @Override
    public List<Schedules> getSchedulesByDateAndUser(Long uidx, Date ndate) {
        return repo.findByUidxAndNdate(uidx, ndate);
    }
}
