class Mood {
  String? moodName;
  String? moodColor;

  Mood(this.moodName, this.moodColor);

  @override
  String toString() {
    return 'Mood{Mood Name: $moodName, Mood Color: $moodColor}';
  }
}

var sampleMood = [
  Mood("Peaceful", "Yellow"),
  Mood("Happy", "Green"),
  Mood("Angry", "Red"),
];
