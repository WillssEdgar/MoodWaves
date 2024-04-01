import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for feed items
    final List<Map<String, String>> feedItems = [
      {
        'title': 'Fire at Seahawk village',
        'content':
            'I would love to have a fire and get into the pool at Seahawk village',
        'author': 'Campus Housing',
        'date': 'Today',
      },
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: feedItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    feedItems[index]['title']!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(feedItems[index]['content']!),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(feedItems[index]['author']!),
                      Text(feedItems[index]['date']!),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
