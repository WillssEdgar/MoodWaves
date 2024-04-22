import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/classes/mood.dart';

void main() {
  group('Mood Class Tests', () {
    // Create Mood objects (user story #5)
    test('Mood Constructor Test', () {
      final mood = Mood("Happy", Colors.green);

      expect(mood.moodName, equals("Happy"));
      expect(mood.moodColor, equals(Colors.green));
    });
  });
}
