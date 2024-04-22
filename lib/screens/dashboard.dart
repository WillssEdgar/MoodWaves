import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_waves/widgets/dashboard_widget.dart';

/// The DashboardPage is a StatelessWidget that displays the DashboardWidget.
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  /// Builds the DashboardPage widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: DashboardWidget()),
      floatingActionButton: FloatingActionButton(
        heroTag: "SignOutBtn",
        onPressed: () async {
          await _signOut(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
