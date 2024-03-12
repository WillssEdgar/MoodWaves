import 'package:flutter/material.dart';
import 'package:mood_waves/classes/PieChart.dart';
import 'package:mood_waves/classes/moodLog.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodLog extends StatefulWidget {
  const MoodLog({super.key});

  @override
  State<MoodLog> createState() => _MoodLogState();
}

class _MoodLogState extends State<MoodLog> {
  late List<MoodInfo> ML = sampleMoodLog;

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Log"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Selected Day: $today"),
            Center(
              child: SizedBox(
                height: 400,
                width: 600,
                child: MyCalendar(
                  selectedDay: today,
                  onDaySelected: _onDaySelected,
                  key: null,
                ),
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  width: 300,
                  child: MyPieChart(moodLog: ML),
                ),
                const Text("Pie Graph"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const MyCalendar(
      {Key? key, required this.selectedDay, required this.onDaySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
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
    );
  }
}
