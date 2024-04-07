import 'package:flutter/material.dart';
import 'package:mood_waves/model/card_model.dart';

/// The CardDetails class contains the cardData list that contains the data for the cards displayed on the dashboard.
class CardDetails {
  final String consecutiveDays;
  late final List<CardModel> cardData;

  CardDetails({required this.consecutiveDays})
      : cardData = _initializeCardData(consecutiveDays);

  static List<CardModel> _initializeCardData(String consecutiveDays) {
    return [
      const CardModel(
          icon: Icons.event,
          value: "Mental Health Event",
          title: "Next Event:"),
      const CardModel(
          icon: Icons.assignment,
          value: "Write about life",
          title: "Journal Prompt:"),
      const CardModel(
          icon: Icons.emoji_events,
          value: "Gold Level",
          title: "Your Reward Level:"),
      CardModel(
          icon: Icons.local_fire_department,
          value: consecutiveDays,
          title: "Log Streak:"),
      const CardModel(icon: Icons.mood, value: "Happy", title: "Mood:"),
    ];
  }
}
