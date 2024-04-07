import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mood_waves/classes/mood.dart';
import 'package:mood_waves/classes/mood_info.dart';

// A pie chart widget that displays mood distribution based on the provided mood log.
class MyPieChart extends StatelessWidget {
  final MoodInfo moodLog;
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
    List<Mood> moods = moodLog.moodlist;
    Map<String?, int> moodCount = {};

    // Populate mood count map
    for (Mood mood in moods) {
      moodCount[mood.moodName] = ((moodCount[mood.moodName] ?? 0) + 1);
    }

    // Calculate total mood count
    int totalMoodCount = moodCount.values.reduce((sum, count) => sum + count);

    // Get unique colors from mood colors
    List<Color> colors =
        moodLog.moodlist.map((mood) => mood.moodColor).toSet().toList();

    if (moodCount.isEmpty || colors.isEmpty) {
      if (kDebugMode) {
        print("Error: Mood count or colors are empty.");
      }
      return [];
    }
    return List.generate(
      moodCount.length,
      (index) {
        double percentage =
            (moodCount.values.elementAt(index) / totalMoodCount) * 100;
        return PieChartSectionData(
          color: colors[index],
          value: moodCount.values.elementAt(index).toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 45,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
    );
  }
}

Widget buildLegend(MoodInfo moodLog) {
  List<Mood> moods = moodLog.moodlist;
  List<Color> colors = [];
  List<String> colorNames = [];

  for (Mood mood in moods) {
    if (!colors.contains(mood.moodColor)) {
      colors.add(mood.moodColor);
      colorNames.add(mood.moodName ?? "");
    }
  }

  return SizedBox(
    width: 150,
    child: SingleChildScrollView(
      child: Column(
        children: List.generate(
          colors.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: colors[index],
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      colorNames[index],
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
