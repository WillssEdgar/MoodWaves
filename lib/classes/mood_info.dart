import 'package:flutter/material.dart';
import 'package:mood_waves/classes/mood.dart';

/// Class representing mood information for a specific date
class MoodInfo {
  String date;
  List<Mood> moodlist;

  MoodInfo(this.date, this.moodlist);
}

Mood mood1 = Mood("Happy", Colors.green);
Mood mood3 = Mood("Peaceful", Colors.yellow);
Mood mood2 = Mood("Sad", Colors.blue);
Mood mood4 = Mood("Happy", Colors.green);
Mood mood5 = Mood("Happy", Colors.green);
Mood mood6 = Mood("Happy", Colors.green);
Mood mood7 = Mood("Peaceful", Colors.yellow);
var sampleMoodLog =
    MoodInfo("02202024", [mood1, mood2, mood3, mood4, mood5, mood6, mood7]);
