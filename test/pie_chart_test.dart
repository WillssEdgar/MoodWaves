import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';
import 'package:mood_waves/widgets/pie_chart.dart';

void main() {
  group('Pie Chart Tests', () {
    testWidgets("Pie Chart test successful", (WidgetTester tester) async {
      final moodLog = MoodInfo('2024-04-02', [
        Mood('Happy', Colors.yellow),
        Mood('Sad', Colors.blue),
      ]);

      await tester.pumpWidget(MaterialApp(
        home: MyPieChart(moodLog: moodLog, type: "moodlog"),
      ));

      // Verify that the pie chart is rendered
      expect(find.byType(MyPieChart), findsOneWidget);
    });
  });
}
