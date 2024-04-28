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
  final double threshold = 25; // Threshold for the reward to be ready
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
            const SizedBox(height: 30),
            FutureBuilder<DocumentSnapshot>(
              future: firestore.collection('users').doc(userId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    int rewardsCollected = (snapshot.data!.data() as Map<String, dynamic>)['rewardsCollected']?.toInt() ?? 0;
                    return buildRewardsIcons(rewardsCollected);
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
    Widget buildRewardsIcons(int rewardsCollected) {
    String status = getStatus(rewardsCollected);
    Color medalColor = getMedalColor(status);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user, size: 50, color: medalColor),
        Text(status, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }


  String getStatus(int rewardsCollected) {
    switch (rewardsCollected) {
      case 0:
        return 'Starter'; 
      case 1:
        return 'Bronze';
      case 2:
        return 'Silver';
      case 3:
        return 'Black';
      case 4:
        return 'Gold';
      default:
        return 'Starter';  // Default case for when no rewards have been collected
    }
  }
  Color getMedalColor(String status) {
    switch (status) {
      case 'Gold':
        return Colors.amber;
      case 'Black':
        return Colors.black;
      case 'Silver':
        return Colors.grey;
      case 'Bronze':
        return Colors.brown;  // Bronze color
      case 'Starter':
        return Colors.grey;  // Color for Starter level
      default:
        return Colors.grey;  // Default color for no status
    }
  }
 
        

  void collectReward() {
    // Assuming the reward collection sets progress back to 0 or subtracts threshold
    // Remove the unused variable
    rewardProgress -= threshold;

    firestore.collection('users').doc(userId).update({
      'rewardProgress': 0, // Set reward progress to exactly 0 after collection
    }).then((_) async {
        DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
        int rewardsCollected =  (userDoc.data() as Map<String, dynamic>)['rewardsCollected']?.toInt() ?? 0;
        firestore.collection('users').doc(userId).update( {
          'rewardsCollected': rewardsCollected + 1
        });
    
      setState(() {
        rewardProgress = 0; // Also set local state to 0
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
  }
}
