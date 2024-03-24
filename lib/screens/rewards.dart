import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}


class _RewardsPageState extends State<RewardsPage> {
  final double progress = 100; // Change this value to test the button's behavior
  final double threshold = 100; // Threshold for the reward to be ready

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Your Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: 6, // Adjusted for smaller progress bars
                children: List.generate(ranks.length, (index) {
                  double progress = ranks[index] * threshold;
                  bool isButtonReady = progress >= threshold;
                  return _buildHorizontalProgressBarWithButton(
                      index, progress, threshold, isButtonReady);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalProgressBarWithButton(
      int index, double progress, double maxProgress, bool isButtonReady) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Rank: ${ranks[index]}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            SizedBox(
              height: 20,
              width: 150, // Reduced width for shorter progress bars
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress / maxProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text('${ranks[index]} / ${threshold * (ranks[index] + 1)}',
            style: const TextStyle(fontSize: 18)),
        Center(
          child: SizedBox(
            width: 150, // Reduced width for a shorter button
            child: ElevatedButton(
              onPressed: isButtonReady
                  ? () {
                        setState(() {
                          ranks[index] += 1; // Increase the rank for this progress bar
                        });
                        print('Reward collected for Rank ${ranks[index]}!');
                      }
                    : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return isButtonReady ? Colors.green : Colors.grey;
                  },
                ),
              ),
              child: const Text('Collect Reward'),
            ),
          ),
        ),
      ],
    );
  }
}
