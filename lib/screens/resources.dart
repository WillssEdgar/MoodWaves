import 'package:flutter/material.dart';
import 'package:mood_waves/classes/resource_Class.dart';
// import linkify library - web and email

class SearchBarApp extends StatefulWidget{
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}


class _SearchBarAppState extends State<SearchBarApp> {
  // Add search functionality here

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Search Bar Sample')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
           
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          }),
        ),
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
        actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement search functionality
              },
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
      ),
      body: 
      //SearchBarApp;
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
