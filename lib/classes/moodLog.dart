import 'package:flutter/material.dart';
import 'package:mood_waves/classes/mood.dart';

class MoodLog {
  int date;
  List<Mood> moods;

  MoodLog(this.date, this.moods);
}

Mood mood1 = Mood("Happy", Colors.green);
Mood mood2 = Mood("Sad", Colors.blue);
Mood mood3 = Mood("Peaceful", Colors.yellow);
Mood mood4 = Mood("Happy", Colors.green);
Mood mood5 = Mood("Happy", Colors.green);
Mood mood6 = Mood("Happy", Colors.green);
var sampleMoodLog = [
  MoodLog(02202024, [mood1, mood2, mood3, mood4, mood5, mood6]),
];
