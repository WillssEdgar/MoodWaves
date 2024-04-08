import 'package:flutter/material.dart';
import 'package:mood_waves/widgets/details_card.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:mood_waves/classes/mood.dart';
//import 'package:mood_waves/widgets/pie_chart.dart';
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

  @override
  void initState() {
    super.initState();
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

  /// The build method builds the UI of the DashboardWidget.
  /// It displays the DetailsCard widget and the MyPieChart widget.
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return ListView(
      children: [
        Column(
          children: [
            // Place the DetailsCard widget first
            SizedBox(
              height: screenSize.height * 1,
              child: const DetailsCard(),
            ),
          ],
        )
        // Then the MyPieChart widget
        // if (moodInfo.moodlist.isNotEmpty) ...[
        //   SizedBox(
        //     height: 200, // Adjust the size as needed
        //     width: screenSize.width, // Make the chart take full width
        //     child: MyPieChart(moodLog: moodInfo),
        //   ),
        // ] else ...[
        //   const Center(
        //     child: Text("No mood data available"),
        //   ),
        // ],
      ],
    );
  }
}
