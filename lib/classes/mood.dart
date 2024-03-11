import 'package:flutter/material.dart';

class Mood {
  String? moodName;
  Color moodColor;

  Mood(this.moodName, this.moodColor);

  @override
  String toString() {
    return 'Mood{Mood Name: $moodName, Mood Color: $moodColor}';
  }
}

var sampleMood = [
  Mood("Peaceful", Colors.yellow),
  Mood("Happy", Colors.green),
  Mood("Angry", Colors.red),
];
