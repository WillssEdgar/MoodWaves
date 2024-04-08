import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:mood_waves/data/card_details.dart';
import 'package:mood_waves/widgets/custom_card_widget.dart';
import 'package:mood_waves/widgets/pie_chart.dart';

class DetailsCard extends StatefulWidget {
  const DetailsCard({Key? key}) : super(key: key);

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  late String consecutiveDays = '';
  DateTime today = DateTime.now();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late MoodInfo moodInfo;

  @override
  void initState() {
    super.initState();
    updateConsecutiveDays();
    moodInfo = MoodInfo(DateFormat('yyyy-MM-dd').format(today),
        [Mood("No moods entered for this date", Colors.blueGrey.shade100)]);
    _fetchMoodEntry(today);
  }

  /// Fetches the mood data for the selected day from the Firestore database.
  Future<void> _fetchMoodEntry(DateTime selectedDay) async {
    if (userId.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .where('id', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDay))
          .get();

      /// Extract the moodList from the querySnapshot and create a list of Mood objects.
      final List<String> moodList = [];
      for (var doc in querySnapshot.docs) {
        final moodEntry = doc.data();
        if (moodEntry.containsKey('moodList')) {
          List<dynamic> moodListDynamic = moodEntry['moodList'];
          moodList.addAll(moodListDynamic.map((e) => e.toString()));
        }
      }

      /// Create a list of Mood objects from the moodList.
      List<Mood> moods;
      if (moodList.isNotEmpty) {
        moods = moodList
            .map((moodName) => Mood(moodName, getColorForMoodName(moodName)))
            .toList();
      } else {
        moods = [
          Mood("No moods entered for this date", Colors.blueGrey.shade100)
        ];
      }

      /// Update the moodInfo state with the new MoodInfo object.
      /// The MoodInfo object contains the moodList and the selected date.
      setState(() {
        moodInfo =
            MoodInfo(DateFormat('yyyy-MM-dd').format(selectedDay), moods);
      });
    }
  }

  /// Returns a color based on the mood name.
  /// The color is used to display the mood in the MyPieChart widget.
  Color getColorForMoodName(String moodName) {
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
        return Colors.blueGrey.shade100;
    }
  }

  Future<void> updateConsecutiveDays() async {
    final streak = await calculateStreakForPerson(userId);
    setState(
      () {
        consecutiveDays = streak.toString();
      },
    );
  }

  /// Builds the DetailsCard widget.
  @override
  Widget build(BuildContext context) {
    final studentDetails = CardDetails(
        consecutiveDays: consecutiveDays,
        pieChart: MyPieChart(
          moodLog: moodInfo,
          type: "dashboard",
        ));
    double cardHeight = 150; // Adjust based on your design
    double verticalSpacing = 12.0; // Adjust based on your design
    double headerPadding = 20.0; // Additional padding if needed
    int rowCount = (studentDetails.cardData.length / 2).ceil();
    double gridHeight =
        rowCount * (cardHeight + verticalSpacing) + headerPadding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Dashboard'),
      ),
      body: SizedBox(
        height: gridHeight,
        child: GridView.builder(
          itemCount: studentDetails.cardData.length,
          physics:
              const NeverScrollableScrollPhysics(), // Disables scrolling within the GridView
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: verticalSpacing,
            childAspectRatio:
                (MediaQuery.of(context).size.width / 2) / cardHeight,
          ),
          itemBuilder: (context, index) => CustomCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(studentDetails.cardData[index].icon),
                Text(studentDetails.cardData[index].title),
                Text(studentDetails.cardData[index].value),
                if (studentDetails.cardData[index].widget != null) ...[
                  SizedBox(
                      height: 58, child: studentDetails.cardData[index].widget)
                ] else ...[
                  const SizedBox(),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int streakOfDates(List<DateTime> dates) {
  final datesSet = dates.toSet();

  int currentStreak = 1;

  for (final date in datesSet) {
    if (datesSet.contains(date.subtract(const Duration(days: 1)))) {
      currentStreak++;
    } else {
      return currentStreak;
    }
  }

  return currentStreak;
}

// Function to fetch dates for a particular person and calculate the streak
Future<int> calculateStreakForPerson(String userId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('moodEntries')
      .orderBy('id', descending: true)
      .get();

  final dateFormat = DateFormat('yyyy-MM-dd');
  final dates =
      querySnapshot.docs.map((doc) => dateFormat.parse(doc['id'])).toList();

  dates.sort((b, a) => a.compareTo(b));
  final streak = streakOfDates(dates);

  return streak;
}
