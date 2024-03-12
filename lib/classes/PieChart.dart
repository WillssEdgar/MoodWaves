import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/moodLog.dart';

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
          sectionsSpace: 0,
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    List<Color> colors = [];
    List<Mood> moods = [];

    for (int i = 0; i < moodLog.length; i++) {
      for (int j = 0; j < moodLog[i].moodlist.length; j++) {
        moods.add(moodLog[i].moodlist[i]);
      }
    }

    Map<String?, double> moodCount = {};

    for (int i = 0; i < moods.length; i++) {
      if (!colors.contains(moods[i].moodColor)) {
        colors.add(moods[i].moodColor);
      }
    }

    for (Mood mood in moods) {
      if (colors.isEmpty || !colors.contains(mood.moodColor)) {
        colors.add(mood.moodColor);
      }
      moodCount[mood.moodName] = ((moodCount[mood.moodName] ?? 0) + 1);
    }

    List<double> values =
        moodCount.values.map((count) => count.toDouble()).toList();

    double amount = 0;
    for (double d in values) {
      amount += d;
    }

    double x = 100 / amount;

    return List.generate(
      colors.length,
      (index) {
        return PieChartSectionData(
          color: colors[index],
          value: values[index],
          title: '${(values[index] * x).toInt()}%',
          radius: 30,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
          ),
        );
      },
    );
  }
}
