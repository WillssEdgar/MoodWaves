import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_waves/classes/journalEntry_Class.dart';
import 'package:mood_waves/screens/journalEntry.dart'; // Ensure this matches the location of your JournalEntryEditScreen class
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Needed for JSON encoding/decoding

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> entries = []; // Initializes with an empty list

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _printCurrentSavedEntries();
  }

  Future<void> _printCurrentSavedEntries() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('journalEntries'));
  }

  // Future<void> _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString('journalEntries');
    if (entriesJson != null) {
      setState(() {
        entries = (json.decode(entriesJson) as List)
            .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String entriesJson =
        json.encode(entries.map((e) => e.toJson()).toList());
    await prefs.setString('journalEntries', entriesJson);
  }

  void _addJournalEntry(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Journal Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(hintText: "Body"),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final newEntry = JournalEntry(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  body: _bodyController.text,
                  date: DateTime.now(),
                );
                setState(() {
                  entries.add(newEntry);
                });
                _titleController.clear();
                _bodyController.clear();
                _saveEntries(); // Save entries after adding a new one
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              subtitle: Text(
                  "${entry.date} - Mood: ${entry.mood ?? 'Not specified'}"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => JournalEntryEditScreen(
                      entry: entry,
                      onSave: (updatedEntry) {
                        setState(() {
                          int foundIndex = entries
                              .indexWhere((e) => e.id == updatedEntry.id);
                          if (foundIndex != -1) {
                            entries[foundIndex] = updatedEntry;
                            _saveEntries(); // Save entries after updating
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create an empty JournalEntry
          final newEntry = JournalEntry(
            id: DateTime.now()
                .toString(), // Unique ID based on the current time
            title: '', // Empty title
            body: '', // Empty body
            date: DateTime.now(), // Current date and time
            mood: null, // No mood specified
          );

          // Navigate to the JournalEntryEditScreen with the new, empty entry
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JournalEntryEditScreen(
                entry: newEntry,
                onSave: (updatedEntry) {
                  // Add the new entry to the list if it's not empty (or implement your own logic here)
                  if (updatedEntry.title.isNotEmpty ||
                      updatedEntry.body.isNotEmpty) {
                    setState(() {
                      entries.add(updatedEntry);
                    });
                    _saveEntries(); // Save entries after adding a new one
                  }
                },
              ),
            ),
          );
        },
        tooltip: 'Add Entry',
        child: const Icon(
          Icons.add,
          color: Colors.teal, // Add this line
        ),
      ),
    );
  }
}

//  ElevatedButton(
//   onPressed: () async {
//     await _signOut();
//     // Optionally, navigate back to the login screen or reset the app state post-sign-out
//     Navigator.of(context).pushReplacementNamed('/login'); // Assuming '/login' is your login screen route
//   },
//   child: Text('Sign Out'),
// )