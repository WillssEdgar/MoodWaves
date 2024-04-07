import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_waves/data/card_details.dart';
import 'package:mood_waves/widgets/custom_card_widget.dart';

class DetailsCard extends StatefulWidget {
  const DetailsCard({Key? key}) : super(key: key);

  @override
  _DetailsCardState createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  late String consecutiveDays = '';
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    updateConsecutiveDays();
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
    final studentDetails = CardDetails(consecutiveDays: consecutiveDays);
    double cardHeight = 150.0; // Adjust based on your design
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int longestConsecutiveStreak(List<DateTime> dates) {
  final datesSet = dates.toSet();

  int longestStreak = 0;
  int currentStreak = 1;

  for (final date in datesSet) {
    if (datesSet.contains(date.add(const Duration(days: 1)))) {
      currentStreak++;
    } else {
      longestStreak =
          longestStreak > currentStreak ? longestStreak : currentStreak;
      currentStreak = 1;
    }
  }

  return longestStreak;
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
  final streak = longestConsecutiveStreak(dates);

  return streak;
}
