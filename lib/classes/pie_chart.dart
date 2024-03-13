import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';

// A pie chart widget that displays mood distribution based on the provided mood log.
class MyPieChart extends StatelessWidget {
  final List<MoodInfo> moodLog;
  const MyPieChart({required this.moodLog, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PieChart(
        PieChartData(
          sections: _generateSections(),
          borderData: FlBorderData(
            show: false,
          ),
          centerSpaceRadius: 50,
          sectionsSpace: 5,
        ),
      ),
    );
  }

  // Generates the sections for the pie chart based on mood distrubtion.
  List<PieChartSectionData> _generateSections() {
    List<Color> colors = [];
    List<Mood> moods = [];

    for (int i = 0; i < moodLog.length; i++) {
      for (int j = 0; j < moodLog[i].moodlist.length; j++) {
        moods.add(moodLog[i].moodlist[j]);
      }
    }

    Map<String?, int> moodCount = {};

    for (Mood mood in moods) {
      moodCount[mood.moodName] = ((moodCount[mood.moodName] ?? 0) + 1);
      if (!colors.contains(mood.moodColor)) {
        colors.add(mood.moodColor);
      }
    }

    int totalMoodCount = moodCount.values.reduce((sum, count) => sum + count);

    return List.generate(
      moodCount.length,
      (index) {
        double percentage =
            (moodCount.values.elementAt(index) / totalMoodCount) * 100;
        return PieChartSectionData(
          color: colors[index],
          value: moodCount.values.elementAt(index).toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
