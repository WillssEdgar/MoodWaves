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
          print(updatedEntry.toJson()); // Check the format of 'date' before saving

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
  // Check if there are unsaved changes
  if (_titleController.text != widget.entry.title || _bodyController.text != widget.entry.body) {
    // Show a confirmation dialog
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false), // User decides not to leave
          ),
          TextButton(
            child: const Text('Discard'),
            onPressed: () => Navigator.of(context).pop(true), // User decides to leave, discard changes
          ),
        ],
      ),
    );

    return shouldLeave ?? false; // If dialog is dismissed, prevent pop (by returning false)
  }
  // If there are no changes, allow the pop action
  return true;
}


@override
Widget build(BuildContext context) {
  // Use theme data for consistent styling
  final theme = Theme.of(context);

  return WillPopScope(
    onWillPop: _onWillPop,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChangesAndExit, // Save changes and exit when the save icon is tapped
            tooltip: 'Save Changes',
          ),
        ],
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title', style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor)),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Enter title here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text('Body', style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor)),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                hintText: "Enter your journal entry here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              expands: false, // Change to false to make TextField expandable
              maxLines: null, // Allows for any number of lines
              minLines: 5, // Set minLines to null and maxLines to null for expanding
              keyboardType: TextInputType.multiline,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    ),
  );
}

}
