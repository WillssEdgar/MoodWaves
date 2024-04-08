import 'package:flutter/material.dart';
import 'package:mood_waves/model/card_model.dart';

/// The CardDetails class contains the cardData list that contains the data for the cards displayed on the dashboard.
class CardDetails {
  final String consecutiveDays;
  Widget? pieChart;
  late final List<CardModel> cardData;

  CardDetails({required this.consecutiveDays, this.pieChart})
      : cardData = _initializeCardData(consecutiveDays, pieChart);

  static List<CardModel> _initializeCardData(
      String consecutiveDays, Widget? pieChart) {
    return [
      CardModel(
          icon: Icons.event,
          value: "Mental Health Event",
          title: "Next Event:"),
      CardModel(
          icon: Icons.assignment,
          value: "Write about life",
          title: "Journal Prompt:"),
      CardModel(
          icon: Icons.emoji_events,
          value: "Gold Level",
          title: "Your Reward Level:"),
      CardModel(
          icon: Icons.local_fire_department,
          value: consecutiveDays,
          title: "Log Streak:"),
      CardModel(
          icon: Icons.mood, value: "Happy", title: "Mood:", widget: pieChart),
    ];
  }
}
