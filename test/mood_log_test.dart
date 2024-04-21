import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mood_waves/screens/mood_log.dart';
import 'package:mood_waves/widgets/calendar_widget.dart';
import 'package:mood_waves/widgets/mood_slider.dart';
import 'package:mood_waves/widgets/pie_chart.dart';
import 'mocks.dart';

void main() {
  // Set up a mock Firebase app

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // Set up mock instances for FirebaseAuth and Firestore

  group('mood tests', () {
    testWidgets("Mood Log Test", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MoodLog(),
      ));

      expect(find.byType(MoodLog), findsOneWidget);
    });

    testWidgets("Mood Log Test 2", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MoodLog(),
      ));

      expect(
          find.text(
              'Selected Day: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
          findsOneWidget);
      expect(find.byType(MoodSlider), findsOneWidget);

      await tester.tap(find.byKey(Key('submitMood')), warnIfMissed: false);

      expect(find.byType(MyCalendar), findsOneWidget);
      expect(find.byType(MyPieChart), findsOneWidget);

      expect(
          find.text(
              "No Journal Entries for ${DateFormat('yyyy-MM-dd').format(DateTime.now())}"),
          findsOneWidget);

      await tester.pump();

      expect(find.byType(MoodLog), findsOneWidget);
    });
  });
}
