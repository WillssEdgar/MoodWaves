import 'package:flutter/material.dart';

class MoodSlider extends StatefulWidget {
  final Function(double) onColorSelected;

  const MoodSlider({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  double _sliderValue = 0.0;

  void _updateColor(double value) {
    setState(() {
      _sliderValue = value;
    });
    widget.onColorSelected(value);
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
  Colors.yellow.shade400,
  Colors.greenAccent.shade400,
  Colors.blue.shade400,
  Colors.deepPurple.shade300,
  Colors.red.shade400,
];

List<double> timelineStops = [
  0.0,
  0.25,
  0.5,
  0.75,
  1.0,
];
