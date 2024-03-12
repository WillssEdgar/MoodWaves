import 'package:flutter/material.dart';
import 'package:mood_waves/data/card_details.dart';
import 'package:mood_waves/widgets/custom_card_widget.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final studentDetails = CardDetails();

    return GridView.builder(
      itemCount: studentDetails.cardData.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 15, mainAxisSpacing: 12.0),
      itemBuilder: (context, index) => CustomCard(child: Container()),
    );
  }
}
