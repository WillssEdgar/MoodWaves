import 'package:flutter/material.dart';
import 'package:mood_waves/classes/resource_Class.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

// import linkify library - web and email

class ResourcePage extends StatefulWidget{
  const ResourcePage({super.key});

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}


class _ResourcePageState extends State<ResourcePage> {
  // Add search functionality here
  _ResourcePageState();


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Resources Page')), // does not display yet on screen
        body: const Padding( padding: EdgeInsets.all(8.0)),
      ),
    );
  }
}





class ResourcesPage extends StatelessWidget { // Stateless scaffolding
  
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
              child: RescSearchBar()
            ),
          ),
      ),
      body: DynamicLister() // Calls the stateful list widget
    
      
    );
  }
}

class RescSearchBar extends StatefulWidget { // Allows search bar to manipulate the list.
  const RescSearchBar({super.key});

  @override
  State<RescSearchBar> createState() => _RescSearchBarState();
}

class _RescSearchBarState extends State<RescSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
                //onChanged: (String newString){},
                decoration: InputDecoration(
                  hintText: 'Search...', // empty text in search bar
                  border: OutlineInputBorder(),
                ),
              );
  }
}




class DynamicLister extends StatefulWidget {
  const DynamicLister({super.key});
  

  @override
  State<DynamicLister> createState() => _DynamicListerState();
}

class _DynamicListerState extends State<DynamicLister> {
  List<Resource> resources = sampleLists;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
