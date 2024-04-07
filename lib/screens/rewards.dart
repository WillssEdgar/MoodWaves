import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  RewardsPageState createState() => RewardsPageState();
}

class RewardsPageState extends State<RewardsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final double progress =
      100; // Change this value to test the button's behavior

  final double threshold = 100; // Threshold for the reward to be ready
  double rewardProgress = 0; // Initial progress
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _fetchRewardProgress();
  }

  void _fetchRewardProgress() async {
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      setState(() {
        rewardProgress =
            (snapshot.data() as Map<String, dynamic>)['rewardProgress']
                    ?.toDouble() ??
                0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonReady = rewardProgress >= threshold;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Your Progress',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            LinearProgressIndicator(
              value: rewardProgress / threshold,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
              minHeight: 20,
            ),
            const SizedBox(height: 20),
            Text('${rewardProgress.toStringAsFixed(0)} / $threshold',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.card_giftcard),
              label: const Text('Collect Reward'),
              onPressed: isButtonReady ? collectReward : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonReady ? Colors.green : Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void collectReward() {
    // Assuming the reward collection sets progress back to 0 or subtracts threshold
    double newRewardProgress = rewardProgress - threshold;

    firestore.collection('users').doc(userId).update({
      'rewardProgress': newRewardProgress > 0 ? newRewardProgress : 0,
    }).then((_) {
      setState(() {
        rewardProgress = newRewardProgress > 0 ? newRewardProgress : 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reward collected!')),
      );
      if (kDebugMode) {
        print('Reward collected!');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update reward progress: $error");
      }
    });
    final List<int> ranks = [0, 0, 0, 0]; // Initial ranks for each progress bar

    Widget _buildHorizontalProgressBarWithButton(
        int index, double progress, double maxProgress, bool isButtonReady) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Rank: ${ranks[index]}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
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
                        if (kDebugMode) {
                          print('Reward collected for Rank ${ranks[index]}!');
                        }
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
}
