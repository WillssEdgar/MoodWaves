import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_waves/classes/journalEntry_Class.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Add a callback parameter to the constructor to handle saving changes
class JournalEntryEditScreen extends StatefulWidget {
  final JournalEntry entry;
  final Function(JournalEntry) onSave;

  const JournalEntryEditScreen(
      {Key? key, required this.entry, required this.onSave})
      : super(key: key);

  @override
  _JournalEntryEditScreenState createState() => _JournalEntryEditScreenState();
}

class _JournalEntryEditScreenState extends State<JournalEntryEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _bodyController = TextEditingController(text: widget.entry.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveChangesAndExit() async {
    final User? user = auth.currentUser;
    final String userId = user?.uid ?? '';

    if (userId.isNotEmpty) {
      if (_titleController.text != widget.entry.title ||
          _bodyController.text != widget.entry.body) {
        // Update the entry with the new values
        JournalEntry updatedEntry = JournalEntry(
          id: widget.entry
              .id, // Assuming id is still relevant for identifying the entry within the subcollection
          title: _titleController.text,
          body: _bodyController.text,
          date: widget.entry.date,
        );
        showDialog(
          context: context,
          barrierDismissible: false, // User must wait.
          builder: (BuildContext context) {
            return const Dialog(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text("Saving..."),
                ],
              ),
            );
          },
        );
        // Create an instance of the Firestore service
        final firestore = FirebaseFirestore.instance;

        // Define the document reference for the user
        DocumentReference userDocRef =
            firestore.collection('users').doc(userId);

        // Save the updated entry to Firestore under the user's subcollection
        await userDocRef
            .collection('journalEntries')
            .doc(updatedEntry.id)
            .set(updatedEntry.toJson(), SetOptions(merge: true))
            .then((_) {
          print("Journal entry updated successfully.");
          // Show a success message using a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Journal entry updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError((error) {
          print("Failed to update journal entry: $error");
          // Show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update journal entry.'),
              backgroundColor: Colors.red,
            ),
          );
        });

        Navigator.pop(context); // Close the saving dialog

        Navigator.of(context).pop(); // Exit the screen after saving
      }
    } else {
      // Handle the case where no user is signed in, if needed
    }
  }

  Future<bool> _onWillPop() async {
    _saveChangesAndExit(); // Save changes when the user attempts to leave the screen
    return false; // Prevent the default behavior since we're handling navigation manually
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Entry'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed:
                  _saveChangesAndExit, // Save changes and exit when the save icon is tapped
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Title"),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(hintText: "Body"),
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
