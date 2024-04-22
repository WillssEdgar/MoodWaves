import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_waves/classes/journal_entry_class.dart';

import 'package:mood_waves/widgets/pie_chart.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:mood_waves/widgets/calendar_widget.dart';
import 'package:mood_waves/widgets/mood_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Widget for displaying and managing Mood Entries.
class MoodLog extends StatefulWidget {
  const MoodLog({Key? key}) : super(key: key);

  @override
  State<MoodLog> createState() => _MoodLogState();
}

class _MoodLogState extends State<MoodLog> {
  DateTime today = DateTime.now();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late MoodInfo moodInfo = MoodInfo(DateFormat('yyyy-MM-dd').format(today),
      [Mood("No moods entered for this date", Colors.blueGrey.shade100)]);
  late Map<String, Color> moodColors = {};
  Color _selectedColor = Colors.yellow.shade400;

  String latestMoodEntryID = "";
  bool isEntryToday = false;
  double rewardAmount = 0;
  double rewardProgress = 0;

  /// Fetches mood entry for the selected day.
  Future<void> _fetchMoodEntry(DateTime selectedDay) async {
    if (userId.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .where('id', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDay))
          .get();

      final List<String> moodList = [];

      for (var doc in querySnapshot.docs) {
        final moodEntry = doc.data();
        if (moodEntry.containsKey('moodList')) {
          final List<dynamic> moodListDynamic = moodEntry['moodList'];
          moodList.addAll(moodListDynamic.map((e) => e.toString()));
        }
      }
      List<Mood> moods;
      if (moodList.isNotEmpty) {
        moods = moodList.map((moodName) {
          Color moodColor = getColorForMoodName(moodName);
          return Mood(moodName, moodColor);
        }).toList();
      } else {
        moods = [
          Mood("No moods entered for this date", Colors.blueGrey.shade100)
        ];
      }
      setState(() {
        moodInfo =
            MoodInfo(DateFormat('yyyy-MM-dd').format(selectedDay), moods);
      });
    }
  }

  /// Maps mood names to corresponding colors.
  Color getColorForMoodName(String moodName) {
    // Here you can associate mood names with colors
    switch (moodName.toLowerCase()) {
      case 'peaceful':
        return Colors.greenAccent.shade400;
      case 'sad':
        return Colors.blue.shade400;
      case 'angry':
        return Colors.red.shade400;
      case 'sick':
        return Colors.deepPurple.shade300;
      case 'happy':
        return Colors.yellow.shade400;
      default:
        return Colors.blueGrey.shade100; // Default color for unknown mood names
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchJournalEntries(DateTime.now());
    _fetchMoodEntry(DateTime.now());
    _fetchLatestMoodEntryID();
    _fetchUserRewardData();
  }

  Future<void> _fetchUserRewardData() async {
    if (userId.isNotEmpty) {
      final userDocSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDocSnapshot.exists) {
        setState(() {
          rewardAmount = (userDocSnapshot.data() as Map<String, dynamic>)['rewardAmount']?.toDouble() ?? 0;
          rewardProgress = (userDocSnapshot.data() as Map<String, dynamic>)['rewardProgress']?.toDouble() ?? 0;
        });
      }
    }
  }

  Future<void> _fetchLatestMoodEntryID() async {
    if (userId.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          latestMoodEntryID = querySnapshot.docs.first.id;
          isEntryToday = latestMoodEntryID == DateFormat('yyyy-MM-dd').format(DateTime.now());
        });
      }
    }
  }

  late List<JournalEntry> entries = [];

  /// Fetches journal entries for the selected day.
  Future<void> _fetchJournalEntries(DateTime selectedDay) async {
    if (userId.isNotEmpty) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('journalEntries')
          .where('date', isEqualTo: formattedDate)
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

  // Adds mood entries for the selected day and updates reward if it's the first entry of the day
  Future<void> _addToMoodEntries(DateTime selectedDay, String moodName) async {
    if (userId.isNotEmpty) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
      DocumentReference moodEntryDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .doc(formattedDate);

      DocumentSnapshot docSnapshot = await moodEntryDocRef.get();
      List<String> currentMoodList = docSnapshot.exists
          ? List<String>.from((docSnapshot.data() as Map<String, dynamic>)['moodList'] ?? [])
          : [];

      // Add the new mood to the current moodList
      currentMoodList.add(moodName);
      await moodEntryDocRef.set({
        'id': formattedDate,
        'moodList': currentMoodList,
      }, SetOptions(merge: true));

      // Fetch updated mood entry and latest mood entry ID
      await _fetchLatestMoodEntryID();

      // If this is the first mood entry today, update the rewardProgress
      if (!isEntryToday && currentMoodList.length == 1) {
        setState(() {
          rewardProgress += rewardAmount; // Update reward progress
        });
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'rewardProgress': rewardProgress,
        });
      }
      // Fetch mood entry again to update the UI
      _fetchMoodEntry(selectedDay);
    }
  }


  /// Updates the variable today and updates the journal entries and graph
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });

    _fetchJournalEntries(day);
    _fetchMoodEntry(day);
  }

  /// Maps each color to a mood.
  final Map<Color, String> colorNames = {
    Colors.yellow.shade400: 'Happy',
    Colors.greenAccent.shade400: 'Peaceful',
    Colors.red.shade400: 'Angry',
    Colors.blue.shade400: 'Sad',
    Colors.deepPurple.shade300: 'Sick',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Text(
                "Selected Day: ${DateFormat('yyyy-MM-dd').format(today)}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                "Mood Graph",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: MyPieChart(
                        moodLog: moodInfo,
                        type: "moodlog",
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: buildLegend(moodInfo),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Visibility(
                visible: DateFormat('yyyy-MM-dd').format(today) ==
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Create a New Mood",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MoodSlider(
                            onColorSelected: (value) {
                              int index =
                                  (value * (timelineColors.length - 1)).round();
                              setState(() {
                                _selectedColor = timelineColors[index];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Selected Color: ${colorNames[_selectedColor] ?? 'Unknown'}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _addToMoodEntries(
                              today, colorNames[_selectedColor] ?? 'Unkown');
                          _fetchMoodEntry(today);
                        },
                        child: const Text("Submit Mood"),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isEntryToday) ...[
          Text(
            "No entry today",
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Reward Progress: $rewardProgress",
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: () {
              // Call _addToMoodEntries when the button is pressed
              _addToMoodEntries(DateTime.now(), colorNames[_selectedColor] ?? 'Unknown');
            },
            child: const Text("Submit Mood"),
          ),
        ],
              const SizedBox(height: 60),
              if (entries.isNotEmpty) ...[
                const Text(
                  "Journal Entries",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: entries
                      .map((entry) => Align(
                          alignment: Alignment.centerLeft,
                          child: DisplayJournal(journalEntry: entry)))
                      .toList(),
                ),
              ] else ...[
                Text(
                  "No Journal Entries for ${DateFormat('yyyy-MM-dd').format(today)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Creates the widget that displays the journal.
class DisplayJournal extends StatelessWidget {
  final JournalEntry journalEntry;

  const DisplayJournal({Key? key, required this.journalEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
