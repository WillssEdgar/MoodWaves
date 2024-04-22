import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/classes/mood_info.dart';

void main() {
  group('MoodInfo Class Tests', () {
    // Create MoodInfo objects (user story #5)
    test('MoodInfo Constructor Test', () {
      final moodInfo = MoodInfo(
          "02202024", [mood1, mood2, mood3, mood4, mood5, mood6, mood7]);

      expect(moodInfo.date, equals("02202024"));
      expect(moodInfo.moodlist,
          equals([mood1, mood2, mood3, mood4, mood5, mood6, mood7]));
    });

    // Create a sample Mood Log
    test('Sample Moods Test', () {
      expect(sampleMoodLog2.length, equals(3));

      expect(sampleMoodLog2[1].date, equals("03012024"));
      expect(sampleMoodLog2[1].moodlist, equals([mood2, mood4, mood7]));
    });
  });
}

var sampleMoodLog2 = [
  MoodInfo("02012024", [mood1, mood2, mood3, mood4, mood5, mood6, mood7]),
  MoodInfo("03012024", [mood2, mood4, mood7]),
  MoodInfo("04012024", [mood5])
];
