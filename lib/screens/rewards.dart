import 'package:flutter/material.dart';

class RewardsPage extends StatelessWidget {
  
  final double progress = 0.6; 

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
            _buildVerticalProgressBar(progress),
            const SizedBox(height: 20),
            const Text('Rewards at various levels will be listed here.', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalProgressBar(double progress) {
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
            heightFactor: progress,
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
