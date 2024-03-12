import 'package:flutter/material.dart';
import 'package:mood_waves/widgets/dashboard_widget.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: DashboardWidget()));
  }
}
