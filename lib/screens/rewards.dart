import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final double progress =
      100; // Change this value to test the button's behavior
  final double threshold = 100; // Threshold for the reward to be ready

  @override
  Widget build(BuildContext context) {
    // Determine if the button should be ready based on the progress
    bool isButtonReady = progress >= threshold;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Your Progress',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildVerticalProgressBar(progress, threshold),
            const SizedBox(height: 20),
            const Text('Rewards at various levels will be listed here.',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonReady
                  ? () {
                      // Add your reward collection logic here
                      // For testing, you can simply print a message to the console
                      print('Reward collected!');
                    }
                  : null, // Disable the button if the reward is not ready
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return isButtonReady ? Colors.green : Colors.grey;
                  },
                ),
              ),
              child: const Text('Collect Reward'),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a vertical progress bar to visually represent the progress
  Widget _buildVerticalProgressBar(double progress, double maxProgress) {
    double progressRatio = progress / maxProgress;
    return SizedBox(
      height: 200,
      width: 20,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          FractionallySizedBox(
            heightFactor: progressRatio,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
