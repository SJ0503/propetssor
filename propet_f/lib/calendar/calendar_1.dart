import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
import 'package:propetsor/calendar/todayBanner.dart';
import 'package:propetsor/login/login.dart';

class CalendarNon extends StatefulWidget {
  const CalendarNon({super.key});

  @override
  State<CalendarNon> createState() => _CalendarNonState();
}

class _CalendarNonState extends State<CalendarNon> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

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
                events: {}, // 비회원일 때는 빈 이벤트 리스트 전달
              ),
              SizedBox(height: 30),
              TodayBanner(
                selectedDate: selectedDate,
                count: 0,
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '로그인 후 이용해 주세요.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Geekble',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
