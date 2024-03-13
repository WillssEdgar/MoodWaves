import 'package:flutter/material.dart';
import 'package:mood_waves/classes/pie_chart.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:table_calendar/table_calendar.dart';

// Mood log screen
class MoodLog extends StatefulWidget {
  const MoodLog({super.key});

  @override
  State<MoodLog> createState() => _MoodLogState();
}

class _MoodLogState extends State<MoodLog> {
  late List<MoodInfo> moodInfoList = sampleMoodLog;

  DateTime today = DateTime.now();

  // function to handle day selection
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
                height: 360,
                width: 400,
                child: MyCalendar(
                  selectedDay: today,
                  onDaySelected: _onDaySelected,
                  key: null,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Mood Graph",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 200,
                        width: 300,
                        child: MyPieChart(moodLog: moodInfoList),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                _buildLegend(moodInfoList),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying a calendar
class MyCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const MyCalendar(
      {Key? key, required this.selectedDay, required this.onDaySelected})
      : super(key: key);

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

// Widget for building a legend displaying mood color names
Widget _buildLegend(List<MoodInfo> moodLog) {
  List<Mood> moods = moodLog.expand((info) => info.moodlist).toList();
  List<Color> colors = [];
  List<String> colorNames = [];

  for (Mood mood in moods) {
    if (!colors.contains(mood.moodColor)) {
      colors.add(mood.moodColor);
      colorNames.add(mood.moodName ?? "");
    }
  }

  return SizedBox(
    width: 150,
    child: SingleChildScrollView(
      // Wrap with SingleChildScrollView
      child: Column(
        children: List.generate(
          colors.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: colors[index],
                  ),
                  const SizedBox(width: 8),
                  Text(colorNames[index]),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
