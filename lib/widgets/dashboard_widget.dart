import 'package:flutter/material.dart';
import 'package:mood_waves/widgets/details_card.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: DetailsCard(),
          ),
        ],
      ),
    ));
  }
}
