import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_waves/classes/journalEntry_Class.dart';
import 'package:mood_waves/classes/pie_chart.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:mood_waves/widgets/mood_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodLog extends StatefulWidget {
  const MoodLog({Key? key}) : super(key: key);

  @override
  State<MoodLog> createState() => _MoodLogState();
}

class _MoodLogState extends State<MoodLog> {
  late List<MoodInfo> moodInfoList = sampleMoodLog;

  // late JournalEntry sampleEntries = JournalEntry(
  //   id: "1",
  //   title: "Sunny Day Reflections",
  //   body:
  //       "Today was exceptionally sunny and bright. I spent some time walking in the park, enjoying the warmth and the vibrant colors around me. It's moments like these that make me feel truly grateful for the simple joys in life.",
  //   date: DateTime(2024, 3, 10),
  //   mood: "Happy",
  // );

  late List<JournalEntry> entries = [];
  // late List<MoodInfo> moodInfoList = [];

  @override
  void initState() {
    super.initState();
    fetchJournalEntries(DateTime.now());
    // fetchMoodInfoList();
  }

  void fetchJournalEntries(DateTime selectedDay) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      //String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('journalEntries')
          //.where('id', isEqualTo: formattedDate)
          .get();

      final entriesList = querySnapshot.docs
          .map((doc) =>
              JournalEntry.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        entries = entriesList;
      });
    }
  }

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
    fetchJournalEntries(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Log"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selected Day: ${DateFormat('yyyy-MM-dd').format(today)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Selected Day: $today",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 360,
                width: 400,
                child: MyCalendar(
                  selectedDay: today,
                  onDaySelected: _onDaySelected,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Mood Graph",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    width: 300,
                    child: MyPieChart(moodLog: moodInfoList),
                  ),
                ),
                const SizedBox(width: 20),
                _buildLegend(moodInfoList),
              ],
            ),
            const Row(
              children: [
                Expanded(
                  child: MoodSlider(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Journal Entry",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: entries
                  .map((entry) => DisplayJournal(journalEntry: entry))
                  .toList(),
            ),
            // DisplayJournal(journalEntry: sampleEntries),
          ],
        ),
      ),
    );
  }
}

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

class DisplayJournal extends StatelessWidget {
  final JournalEntry journalEntry;

  const DisplayJournal({Key? key, required this.journalEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            journalEntry.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('yyyy-MM-dd').format(journalEntry.date),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            journalEntry.body,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
