import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
import 'package:propetsor/calendar/scheduleBottomSheet.dart';
import 'package:propetsor/calendar/scheduleCard.dart';
import 'package:propetsor/calendar/schedule_service.dart';
import 'package:propetsor/calendar/todayBanner.dart';
import 'package:propetsor/model/Schedules.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CalendarUser extends StatefulWidget {
  const CalendarUser({super.key});

  @override
  State<CalendarUser> createState() => _CalendarUserState();
}

class _CalendarUserState extends State<CalendarUser> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final ScheduleService _scheduleService = ScheduleService();
  Map<DateTime, List<Schedules>> schedules = {};
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadAllSchedules();
  }

  Future<void> _loadAllSchedules() async {
    String? uidx = await storage.read(key: 'uidx');
    if (uidx != null) {
      final data = await _scheduleService.getSchedulesByUserId(int.parse(uidx));
      setState(() {
        schedules = _groupSchedulesByDate(data);
        // 로그를 추가하여 데이터가 잘 로드되었는지 확인
        print("전체 일정 데이터: $schedules");
        _loadSchedulesByDate(selectedDate); // 선택된 날짜의 일정을 로드
      });
    }
  }

  Map<DateTime, List<Schedules>> _groupSchedulesByDate(List<Schedules> allSchedules) {
    Map<DateTime, List<Schedules>> groupedSchedules = {};
    for (var schedule in allSchedules) {
      DateTime date = DateTime.parse(schedule.ndate);
      date = DateTime(date.year, date.month, date.day); // 시간을 제거하여 날짜만 사용
      if (groupedSchedules[date] == null) {
        groupedSchedules[date] = [];
      }
      groupedSchedules[date]!.add(schedule);
    }
    return groupedSchedules;
  }

  Future<void> _loadSchedulesByDate(DateTime date) async {
    String? uidx = await storage.read(key: 'uidx');
    if (uidx != null) {
      final data = await _scheduleService.getSchedulesByDateAndUser(
          int.parse(uidx), date.toIso8601String().split('T')[0]);
      setState(() {
        schedules[date] = data;
      });
    }
  }

  void _createSchedule(Map<String, dynamic> scheduleData) async {
    String? uidx = await storage.read(key: 'uidx');
    if (uidx != null) {
      Schedules schedule = Schedules(
        startTime: scheduleData['startTime'],
        endTime: scheduleData['endTime'],
        content: scheduleData['content'],
        uidx: int.parse(uidx),
        ndate: DateTime.parse(scheduleData['ndate']).toIso8601String().split('T')[0],
      );
      await _scheduleService.createSchedule(schedule);
      _loadAllSchedules(); // 새 일정을 추가한 후 모든 일정을 다시 로드
    }
  }

  void _deleteSchedule(int sidx) async {
    await _scheduleService.deleteSchedule(sidx);
    _loadAllSchedules(); // 일정을 삭제한 후 모든 일정을 다시 로드
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
    _loadSchedulesByDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
                events: schedules,
              ),
              TodayBanner(
                selectedDate: selectedDate,
                count: schedules[selectedDate]?.length ?? 0,
              ),
              SizedBox(height: 6),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: schedules[selectedDate]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final schedule = schedules[selectedDate]![index];
                        return ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                          onDelete: () => _deleteSchedule(schedule.sidx!),
                        );
                      },
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 82,
                        width: 60,
                        margin: EdgeInsets.only(right: 5.0, top: 3.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ScheduleBottomSheet(onSave: _createSchedule),
                              isScrollControlled: true,
                            );
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
