import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  final List<Map<String, String>> resources = [
    {
      "title": "National Mental Health Helpline",
      "description": "Available 24/7 for mental health support.",
      "url": "tel:1-800-662-HELP",
    },
    {
      "title": "Crisis Text Line",
      "description": "Text HOME to 741741 for free, 24/7 crisis support.",
      "url": "sms:741741",
    },
    {
      "title": "Campus Counseling Center",
      "description": "Professional counseling services for students.",
      "url": "https://yourcollege.edu/counseling",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Resources'),
      ),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return ListTile(
            title: Text(resource['title']!),
            subtitle: Text(resource['description']!),
          );
        },
      ),
    );
  }
}
