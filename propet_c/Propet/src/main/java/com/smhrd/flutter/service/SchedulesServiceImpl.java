package com.smhrd.flutter.service;

import java.sql.Date;
import java.util.List;

import com.smhrd.flutter.model.Schedules;

public interface SchedulesServiceImpl {
	 	Schedules createSchedule(Schedules schedule);
	    List<Schedules> getAllSchedules();
	    Schedules getScheduleById(Long sidx);
	    void deleteSchedule(Long sidx);
	    List<Schedules> getSchedulesByUserId(Long uidx);
	    List<Schedules> getSchedulesByDateAndUser(Long uidx, Date ndate);
}
