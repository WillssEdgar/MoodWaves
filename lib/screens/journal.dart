import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_waves/classes/journal_entry_class.dart';
import 'package:mood_waves/screens/journal_entry.dart'; // Ensure this matches the location of your JournalEntryEditScreen class
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  JournalPageState createState() => JournalPageState();
}

class JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = []; // Initializes with an empty list

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}


  Future<void> _loadEntries() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('journalEntries')
          .orderBy('date',
              descending: true) // Assuming you want to order by date
          .get();

      final entriesList = querySnapshot.docs
          .map((doc) => JournalEntry.fromJson(doc.data()))
          .toList();
      setState(() {
        entries = entriesList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              title: Text(entry.title),
              subtitle: Text("${entry.date}"), // Removed an extra apostrophe
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => JournalEntryEditScreen(
                      entry: entry,
                      onSave: (JournalEntry updatedEntry) async {
                        // Store a reference to the Navigator's state before the async gap.
                        final navigator = Navigator.of(context);

                        // Refresh entries from Firestore after an update
                        await _loadEntries();

                        // Check if the widget is still mounted before calling `pop`
                        if (navigator.mounted) {
                          navigator
                              .pop(); // Optionally, pop the edit screen automatically
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

floatingActionButton: Column(
  mainAxisAlignment: MainAxisAlignment.end, // Align at the end of the screen
  children: [
    FloatingActionButton(
      onPressed: () async {
        await _signOut();
        Navigator.of(context).pushReplacementNamed('/login'); // Assuming '/login' is your login screen route
      }, // Icon for sign out
      backgroundColor: Colors.red,
      child: const Icon(Icons.exit_to_app), // Red color for emphasis on sign out
    ),
    const SizedBox(height: 16), // Space between buttons
    FloatingActionButton(
      onPressed: () {
        final BuildContext currentContext = context;
        final newEntry = JournalEntry(
          id: DateTime.now().toString(),
          title: '',
          body: '',
          date: DateTime.now(),
        );
        Navigator.of(currentContext).push(
          MaterialPageRoute(
            builder: (context) => JournalEntryEditScreen(
              entry: newEntry,
              onSave: (JournalEntry updatedEntry) async {
                if (updatedEntry.title.isNotEmpty || updatedEntry.body.isNotEmpty) {
                  await _loadEntries();
                  if (mounted) {
                    Navigator.of(currentContext).pop();
                  }
                }
              },
            ),
          ),
        );
      },
      tooltip: 'Add Entry',
      child: const Icon(Icons.add),
    ),
  ],
),


    );
  }
}



// FloatingActionButton(
//         onPressed: () {
//           // Create an empty JournalEntry
//           final newEntry = JournalEntry(
//             id: DateTime.now()
//                 .toString(), // Unique ID based on the current time
//             title: '', // Empty title
//             body: '', // Empty body
//             date: DateTime.now(), // Current date and time
//           );

//           // Navigate to the JournalEntryEditScreen with the new, empty entry
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => JournalEntryEditScreen(
//                 entry: newEntry,
//                 onSave: (JournalEntry updatedEntry) async {
//                   if (updatedEntry.title.isNotEmpty ||
//                       updatedEntry.body.isNotEmpty) {
//                     await _loadEntries(); // Refresh the list from Firestore
//                     Navigator.of(context)
//                         .pop(); // Optionally, pop the edit screen automatically
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//         tooltip: 'Add Entry',
//         child: const Icon(
//           Icons.add,
//           color: Colors.teal,
//         ),
//       ),