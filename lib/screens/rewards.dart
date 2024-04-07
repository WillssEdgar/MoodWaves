import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final double progress =
      100; // Change this value to test the button's behavior
  final double threshold = 100; // Threshold for the reward to be ready
  final List<int> ranks = [0, 0, 0, 0]; // Initial ranks for each progress bar

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
            const Text('Your Progress',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: 3, // Adjusted for smaller progress bars
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Rank: ${ranks[index]}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Flexible(
              child: SizedBox(
                height: 20,
                width: 150,
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
            ),
          ],
        ),
        Text('${ranks[index]} / ${threshold * (ranks[index] + 1)}',
            style: const TextStyle(fontSize: 18)),
        Center(
          child: SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: isButtonReady
                  ? () {
                      setState(() {
                        ranks[index] += 1;
                      });
                      // firestore.collection('rewards').doc('user1').update({ 'rank': ranks[index]});
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
