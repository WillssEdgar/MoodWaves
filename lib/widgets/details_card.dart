import 'package:flutter/material.dart';
import 'package:mood_waves/data/card_details.dart';
import 'package:mood_waves/widgets/custom_card_widget.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final studentDetails = CardDetails();
    double cardHeight = 150.0; // Adjust based on your design
    double verticalSpacing = 12.0; // Adjust based on your design
    double headerPadding = 20.0; // Additional padding if needed
    int rowCount = (studentDetails.cardData.length / 2).ceil();
    double gridHeight =
        rowCount * (cardHeight + verticalSpacing) + headerPadding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Dashboard'),
      ),
      body: SizedBox(
        height: gridHeight,
        child: GridView.builder(
          itemCount: studentDetails.cardData.length,
          physics:
              const NeverScrollableScrollPhysics(), // Disables scrolling within the GridView
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: verticalSpacing,
            childAspectRatio:
                (MediaQuery.of(context).size.width / 2) / cardHeight,
          ),
          itemBuilder: (context, index) => CustomCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(studentDetails.cardData[index].icon),
                Text(studentDetails.cardData[index].title),
                Text(studentDetails.cardData[index].value),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
