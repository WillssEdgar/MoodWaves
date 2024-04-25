
import 'package:flutter/material.dart';
import '/classes/resource_class.dart';
import 'package:url_launcher/url_launcher.dart';

/// Creates a page for the Resources on the app
///
/// Returns a functioning page
class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcePageState();
}

/// Alters the state of the [ResourcesPage] based on input
///
///
class _ResourcePageState extends State<ResourcesPage>
    implements SearchBarChangeListener {
  _ResourcePageState();

  

  
  List<Resource> resources = [];

  @override

  initState() {
      super.initState;
    _loadResourcesFromFirestore();

  }

  Future<void> _loadResourcesFromFirestore() async{
  List<Resource> returnedList = await sampleLists;
  List<Resource> newList = resources + returnedList;
  setState((){

    resources = newList;
  });
;
}

  @override

  /// Whenever searchbar is changed, sort the list, comparing each member
  ///
  /// Changes the resources value, swapping locations
  void onSearchbarChanged(String searchbarVal) {
    // implement onSearchbarChanged
    resources.sort((b, a) => // Swapping a and b made list work!
        _similarity(a.resourceName, searchbarVal)
            .compareTo(_similarity(b.resourceName, searchbarVal)));

    setState(() {
      resources = resources;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    if (resources.isEmpty) {

      CircularProgressIndicator();
    }

    if (resources.isNotEmpty) {

    }

    return MaterialApp(
        theme: themeData,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Mental Health Resources'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RescSearchBar(listener: this)),
              ),
            ),
            body: DynamicLister(
              resources: resources,
            ) // Calls the stateful list widget
            ));
  }
}

/// Creates a stateful widget, creating a search bar
///
/// Returns a functioning searchbar
class RescSearchBar extends StatefulWidget {
  // Allows search bar to manipulate the list.
  final SearchBarChangeListener listener;
  const RescSearchBar({super.key, required this.listener});

  @override
  State<RescSearchBar> createState() => _RescSearchBarState();
}

/// Handles changes to the state of the search bar
class _RescSearchBarState extends State<RescSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (newText) {

        String validText = _ValidatorFunct(newText); // Validates the input
        setState(() {
          widget.listener.onSearchbarChanged(validText);
        });
      },
      decoration: const InputDecoration(
        hintText: 'Search...', // empty text in search bar
        border: OutlineInputBorder(),
      ),
    );
  }
}

///
class DynamicLister extends StatefulWidget {
  const DynamicLister({super.key, required this.resources});
  final List<Resource> resources;

  @override
  State<DynamicLister> createState() => _DynamicListerState();
}

/// Creates each item in the list, every time it is changed
class _DynamicListerState extends State<DynamicLister> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.resources.length,
      itemBuilder: (context, index) {
        final finalResource = widget.resources[index];

        return ListTile(
          title: Text(finalResource.resourceName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(finalResource.resourceDesc),
              ElevatedButton(
                  onPressed: () => _launchURL(finalResource.resourceURL),
                  child: Text(finalResource.resourceURL,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 32, 104, 163),
                      ))),
            ],
          ),
          // text: Text(resource.resourceURL),
        );
      },
    );
  }
}

/// Function to calculate similarity between two strings (generated by ChatGPT)
double _similarity(String a, String b) {
  int matchingChars = 0;
  for (int i = 0; i < a.length && i < b.length; i++) {
    if (a[i] == b[i]) {
      matchingChars++;
    }
  }

  return matchingChars / a.length; // Similarity ratio
}

/// Void function based on ChatGPT, launches the URL when clicked.
Future<void> _launchURL(String url) async {
  // based on ChatGPT, launches the URL when clicked.
  Uri workingUri = Uri.parse(url);
  if (await canLaunchUrl(workingUri)) {
    await launchUrl(workingUri);
  } else {
    throw 'Could not launch $url';
  }
}

/// Listener class that indicates the searchBar value has changed
abstract class SearchBarChangeListener {
  void onSearchbarChanged(String value);
}

/// Class that checks input for potentially compromising characters, returns string without them
/// Whitelist, not blacklist
String _ValidatorFunct(stringToValidate) {

  if (stringToValidate.contains(new RegExp(r'^[a-zA-Z0-9 ]*$'))) { // Returns only valid input
    return stringToValidate;
  } else {
    return "";
  }
  

}

