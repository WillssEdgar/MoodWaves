import 'package:flutter/material.dart';


/// Generates the page for the Events tab of the app.
/// 
class EventsPage extends StatelessWidget {


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

    List sortedList = feedItems; // listSorter(feedItems);

    return Scaffold(
      body: ListView.builder(
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    sortedList[index]['title']!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(sortedList[index]['content']!),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(sortedList[index]['author']!),
                      Text(sortedList[index]['location']!),
                      Text(sortedList[index]['datetime']!),
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
 DateTime _dateCreator(String eventDate) {
  final now = DateTime.now();
  List<String> splittedList = eventDate.split(" ");
  splittedList.remove("at");
  // "April" "27" "2:30"


    // Error: Can't convert string to months yet.
  DateTime eventDateTime = DateTime(now.year, int.parse(splittedList[1].toLowerCase()), int.parse(splittedList[0]), int.parse(splittedList[2]));
  return eventDateTime;
}


/// Takes in an unsorted list of events, and based on 
List<dynamic> listSorter(List feedItems) {


  final now = DateTime.now();
  List sortedList = [];
  
  for (var i = 0; i <= feedItems.length; i++) {
    sortedList.add({});

    DateTime indivEventTime = _dateCreator(feedItems[i]['datetime']); 

    if (indivEventTime.isBefore(now)) {

      String expiredTime = (feedItems[i]["datetime"]);
      feedItems[i]["datetime"] = ("Expired: $expiredTime");
      sortedList.add(feedItems[i]);

    } else if (indivEventTime.isAfter(now)) {

      sortedList.insert(feedItems[i],0);

    }


  }

  return sortedList;

}