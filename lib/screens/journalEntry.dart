import 'package:flutter/material.dart';
import 'package:mood_waves/classes/journalEntry_Class.dart';

// Add a callback parameter to the constructor to handle saving changes
class JournalEntryEditScreen extends StatefulWidget {
  final JournalEntry entry;
  final Function(JournalEntry) onSave;

  const JournalEntryEditScreen({Key? key, required this.entry, required this.onSave}) : super(key: key);

  @override
  _JournalEntryEditScreenState createState() => _JournalEntryEditScreenState();
}

class _JournalEntryEditScreenState extends State<JournalEntryEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

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

  void _saveChangesAndExit() {
    if (_titleController.text != widget.entry.title || _bodyController.text != widget.entry.body) {
      // Update the entry with the new values
      JournalEntry updatedEntry = JournalEntry(
        id: widget.entry.id,
        title: _titleController.text,
        body: _bodyController.text,
        date: widget.entry.date, // Use the original date or update it if necessary
        mood: widget.entry.mood, // Keep the original mood or allow it to be edited
      );

      // Call the onSave callback with the updated entry
      widget.onSave(updatedEntry);
    }

    Navigator.of(context).pop(); // Exit the screen
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
              onPressed: _saveChangesAndExit, // Save changes and exit when the save icon is tapped
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
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
