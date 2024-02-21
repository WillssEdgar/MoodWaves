

class JournalEntry {
  final String title;
  final String body;
  final DateTime date;

  JournalEntry({required this.title, required this.body, required this.date});
}

var sampleEntries = [
  JournalEntry(
    title: "First Entry",
    body: "This is the body of the first entry.",
    date: DateTime.now(),
  ),
  JournalEntry(
    title: "Second Entry",
    body: "This is the body of the second entry.",
    date: DateTime.now(),
  ),
  JournalEntry(
    title: "Third Entry",
    body: "This is the body of the third entry.",
    date: DateTime.now(),
  ),
];
