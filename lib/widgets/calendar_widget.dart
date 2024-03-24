import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const MyCalendar({
    Key? key,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: TableCalendar(
        rowHeight: 45,
        locale: "en_US",
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        focusedDay: selectedDay,
        firstDay: DateTime.utc(2023, 12, 31),
        lastDay: DateTime.utc(2030, 12, 31),
        onDaySelected: onDaySelected,
      ),
    );
  }
}
