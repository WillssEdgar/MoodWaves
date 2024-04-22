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
    _entriesStream();
  }



Stream<List<JournalEntry>> _entriesStream() {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  if (userId.isEmpty) {
    return Stream.value([]); // Return an empty stream if the user is not logged in
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('journalEntries')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => JournalEntry.fromJson(doc.data()))
          .toList());
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Journal'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<List<JournalEntry>>(
        stream: _entriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No entries found"));
          }
          final entries = snapshot.data!;
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(entry.title),
                subtitle: Text("${entry.date}"),
                onTap: () => _navigateAndEditEntry(context, entry),
              );
            },
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _navigateAndAddEntry(context),
      tooltip: 'Add Entry',
      child: const Icon(Icons.add),
    ),
  );
}

void _navigateAndEditEntry(BuildContext context, JournalEntry entry) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => JournalEntryEditScreen(
        entry: entry,
        onSave: (JournalEntry updatedEntry) {
          Navigator.of(context).pop();
        },
      ),
    ),
  );
}

void _navigateAndAddEntry(BuildContext context) {
  final newEntry = JournalEntry(
    id: DateTime.now().toString(), // Consider a more robust ID generation strategy
    title: '',
    body: '',
    date: DateTime.now(),
  );
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => JournalEntryEditScreen(
        entry: newEntry,
        onSave: (JournalEntry updatedEntry) {
          Navigator.of(context).pop();
        },
      ),
    ),
  );
}

}

