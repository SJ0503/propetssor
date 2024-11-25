import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:propetsor/model/Schedules.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final Map<DateTime, List<Schedules>> events;

  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        onDaySelected: onDaySelected,
        selectedDayPredicate: (date) =>
        date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day,
        focusedDay: selectedDate,
        firstDay: DateTime(2023, 1, 1),
        lastDay: DateTime(2026, 1, 1),
        eventLoader: (date) {
          return events[date] ?? [];
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Geekble',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6.0),
          ),
          defaultDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
          ),
          weekendDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
          ),
          selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
            border: Border.all(
              color: selectedDate.weekday == DateTime.saturday ||
                  selectedDate.weekday == DateTime.sunday
                  ? Colors.red
                  : Colors.black,
              width: 1.0,
            ),
          ),
          defaultTextStyle: TextStyle(
            fontFamily: 'Omyu',
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.5),
          ),
          weekendTextStyle: TextStyle(
            fontFamily: 'Omyu',
            fontWeight: FontWeight.w600,
            color: Colors.red[300],
          ),
          selectedTextStyle: TextStyle(
            fontFamily: 'Omyu',
            fontWeight: FontWeight.w600,
            color: selectedDate.weekday == DateTime.saturday ||
                selectedDate.weekday == DateTime.sunday
                ? Colors.red
                : Colors.black,
          ),
          todayTextStyle: TextStyle(
            fontFamily: 'Omyu',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          markersMaxCount: 1, // 각 날짜에 최대 1개의 마커만 표시
          markerDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '${events.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
