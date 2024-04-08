import 'package:flutter/material.dart';
import 'package:mood_waves/widgets/dashboard_widget.dart';

/// The DashboardPage is a StatelessWidget that displays the DashboardWidget.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  /// Builds the DashboardPage widget.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: DashboardWidget()));
  }
}
