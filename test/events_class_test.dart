import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/classes/events_class.dart';

void main() {
  group('Mental Health Event Tests', () {
    // Create MentalHealthEvent objects as used on the events page (user story #40)
    test('MentalHealthEvent Constructor Test', () {
      final event = MentalHealthEvent(
          "Check in", DateTime(2024, 10, 14), "Check in with emotions");

      expect(event.name, equals("Check in"));
      expect(event.date, equals(DateTime(2024, 10, 14)));
      expect(event.description, equals("Check in with emotions"));
    });

    // Create a sample list of MentalHealthEvent objects
    test('Sample Events Test', () {
      expect(sampleEvents.length, equals(10));

      expect(sampleEvents[6].name, equals("Sleep"));
      expect(sampleEvents[6].description, contains("Get 8 hours of sleep"));
      expect(sampleEvents[6].date, isA<DateTime>());
    });
  });
}
