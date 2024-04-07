import 'package:flutter/widgets.dart';

/// The CardModel class represents the data for a card displayed on the dashboard.
/// Each card contains an icon, a title, and a value.
/// The CardModel class is used by the CardDetails class to create a list of cards.
/// The CardDetails class is used by the DetailsCard widget to display the cards.
/// The DetailsCard widget is displayed on the dashboard.
class CardModel {
  final IconData icon;
  final String value;
  final String title;

  const CardModel(
      {required this.icon, required this.value, required this.title});
}
