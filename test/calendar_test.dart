import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/widgets/calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  group('Calendar Tests', () {
    testWidgets("Calendar test successful", (WidgetTester tester) async {
      // Define test variables
      DateTime selectedDay = DateTime(2024, 4, 20);
      DateTime callbackDay =
          DateTime(2024, 4, 21); // A day to simulate selection
      DateTime? callbackSelectedDay;

      // Define a callback function to pass to MyCalendar
      void handleDaySelected(DateTime day, DateTime? selectedDay) {
        callbackSelectedDay = selectedDay;
      }

      // Build MyCalendar widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyCalendar(
              selectedDay: selectedDay,
              onDaySelected: handleDaySelected,
            ),
          ),
        ),
      );

      // Verify that TableCalendar is rendered with the correct parameters
      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text('April 2024'),
          findsOneWidget); // Ensure correct header text
      expect(
          find.text('20'), findsOneWidget); // Ensure selected day is displayed

      // Simulate selecting a day
      await tester.tap(find.text('21')); // Simulate tapping on the 21st day
      await tester.pumpAndSettle(); // Wait for animations to complete

      expect(
        callbackSelectedDay!.year,
        callbackDay.year,
      );
      expect(
        callbackSelectedDay!.month,
        callbackDay.month,
      );
      expect(
        callbackSelectedDay!.day,
        callbackDay.day,
      );
    });
  });
}
