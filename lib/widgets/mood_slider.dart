import 'package:flutter/material.dart';

class MoodSlider extends StatefulWidget {
  const MoodSlider({super.key});

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  double _sliderValue = 0.0;
  Color _selectedColor = Colors.red;

  void _updateColor(double value) {
    int index = (value * (timelineColors.length - 1)).round();
    setState(() {
      _sliderValue = value;
      _selectedColor = timelineColors[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: timelineColors,
          stops: timelineStops,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Slider(
        value: _sliderValue,
        onChanged: _updateColor,
        min: 0,
        max: 1,
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
      ),
    );
  }
}

List<Color> timelineColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
];

List<double> timelineStops = [
  0.0,
  0.25,
  0.5,
  0.75,
  1.0,
];
