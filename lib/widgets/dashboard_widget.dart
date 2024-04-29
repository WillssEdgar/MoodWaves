import 'package:flutter/material.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/widgets/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// The DashboardWidget is a StatefulWidget that displays the DetailsCard widget.
/// It also fetches the mood data for the current day and displays the MyPieChart widget.
class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

/// The _DashboardWidgetState class is the state of the DashboardWidget class.
/// It fetches the mood data for the current day and displays the MyPieChart widget.
/// The mood data is fetched from the Firestore database and is displayed in the MyPieChart widget.
class _DashboardWidgetState extends State<DashboardWidget> {
  DateTime today = DateTime.now();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late MoodInfo moodInfo;
  double rewardProgress = 0; // Initial progress
  final double threshold = 100;

  @override
  void initState() {
    super.initState();
    moodInfo = MoodInfo(DateFormat('yyyy-MM-dd').format(today),
        [Mood("No moods entered for this date", Colors.blueGrey.shade100)]);
    _fetchMoodEntry(today);
    _fetchRewardProgress();
    updateConsecutiveDays();
  }

  void _fetchRewardProgress() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      setState(() {
        rewardProgress =
            (snapshot.data() as Map<String, dynamic>)['rewardProgress']
                    ?.toDouble() ??
                0;
      });
    }
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

  late String consecutiveDays = '';
  Future<void> updateConsecutiveDays() async {
    final streak = await calculateStreakForPerson(userId);
    setState(
      () {
        consecutiveDays = streak.toString();
      },
    );
  }

  /// The build method builds the UI of the DashboardWidget.
  /// It displays the DetailsCard widget and the MyPieChart widget.
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            if (moodInfo.moodlist.isNotEmpty) ...[
              Card.filled(
                elevation: 6,
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Mood Chart",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 150,
                                child: MyPieChart(
                                  moodLog: moodInfo,
                                  type: "dashboard",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            SizedBox(
                              width: 90,
                              child: buildLegend(moodInfo),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 175, // Set width to desired value
                    height: 170, // Set height to desired value
                    child: Card.filled(
                      elevation: 6,
                      margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          width: 100,
                          height: 85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Log\nStreak",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                consecutiveDays,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 180, // Set width to desired value
                    height: 170, // Set height to desired value
                    child: Card.filled(
                      elevation: 6,
                      margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Rewards\nProgress",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 15,
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    value: rewardProgress / threshold,
                                    backgroundColor: Colors.grey[500],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.teal),
                                    minHeight: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ] else ...[
              const Center(
                child: Text("No mood data available"),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
