import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {

  /// Generates the 

  @override
  Widget build(BuildContext context) {
    // Dummy data for feed items
    final List<Map<String,  String>> feedItems = [
      {
        'title': "Fire at Seahawk village",
        'content': "Celebrate at the pool, and eat s'mores at the campfire!",
        'author': "Campus Housing",
        'datetime': "April 24 at 5:30PM",
        'location': "Seahawk Village",
      },
      {
        'title':"Spa Day",
        'content':"Take some time to treat yourself!",
        'author':"Seahawk Wellness",
        'datetime': "April 26 at 2:30PM",
        'location': "Leonard Student Recreational Center",

      },
      {
        'title':"Yoga on the Beach",
        'content':"Come join us this morning on the seaside for a calming experience!",
        'author':"UNCW Yoga Association",
        'datetime':"April 27 at 8:00AM",
        'location': "Wrightsville Beach",

      },
      {
        'title':"Handpan Music Festival",
        'content':"Listen to the soothing ringing of these bell-like instruments!",
        'author':"Blue Mountain Group",
        'datetime':"April 28 at 12:30PM",
        'location': "Fisher Student Center",

      },
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: feedItems.length,
        
        itemBuilder: (context, index) {

            String? eventDate = feedItems[index]['datetime'];




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
                      Text(feedItems[index]['location']!),
                      Text(feedItems[index]['datetime']!),
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


/// Returns a checkable time string, allowing cards with closer time 
/// to rise to the top
 void _dateCreator(String eventDate) async {
  DateTime currentDateTime =  DateTime.now(); 
  String dateTimeString = currentDateTime.toString();
}