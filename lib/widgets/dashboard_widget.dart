import 'package:flutter/material.dart';
import 'package:mood_waves/widgets/details_card.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain screen size
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          // Assign a portion of the screen height to the DetailsCard
          height:
              screenSize.height * 0.8, // For example, 80% of the screen height
          child: const DetailsCard(),
        ),
        // You can add more widgets here if needed
      ],
    );
  }
}
