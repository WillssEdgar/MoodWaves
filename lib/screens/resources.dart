import 'package:flutter/material.dart';
import 'package:mood_waves/classes/resource_Class.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

// import linkify library - web and email

class SearchBarApp extends StatefulWidget{
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}


class _SearchBarAppState extends State<SearchBarApp> {
  // Add search functionality here
  bool loading = true;

  _SearchBarAppState();


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Search Bar Sample')), // does not display yet on screen
        body: const Padding( padding: EdgeInsets.all(8.0)),
      ),
    );
  }
}





class ResourcesPage extends StatelessWidget {
  final List<Resource> resources = sampleLists;
// Most of searchbar design from ChatGPT
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Resources'), 
        // note to self: actions[] was here, deleted to get rid of search button
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                // onChanged: might go here, can shift order of list 
                decoration: InputDecoration(
                  hintText: 'Search...', // empty text in search bar
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
      ),
      body: 
      //SearchBarApp; create a dynamic list
      ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return ListTile(
            title: Text(resource.resourceName),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
             children: [
          Text(resource.resourceDesc),
          Text(resource.resourceURL,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 32, 104, 163),
            ),
          ),
        ],
            ),
            // text: Text(resource.resourceURL),
          );
        
        },
      ),
    );
  }
}
