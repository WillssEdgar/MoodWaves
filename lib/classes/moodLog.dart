import 'package:mood_waves/classes/mood.dart';

class MoodLog {
  int consecutiveDays;
  int date;
  Mood mood;

  MoodLog(this.consecutiveDays, this.date, this.mood);
}

Mood mood1 = Mood("Happy", "Green");
Mood mood2 = Mood("Sad", "Blue");
Mood mood3 = Mood("Peaceful", "Yellow");
var sampleMoodLog = [
  MoodLog(33, 02202024, mood1),
  MoodLog(22, 02202024, mood2),
  MoodLog(10, 02202024, mood3),
];
