import 'dart:convert';

class JournalEntry {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String? mood; // Optional: to capture the user's mood

  JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.mood,
  });

  // Convert a JournalEntry instance into a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(), // Convert DateTime to a String
      'mood': mood,
    };
  }

  // Create a JournalEntry instance from a map
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']), // Convert String to DateTime
      mood: json['mood'],
    );
  }
}

// Encode the list of JournalEntry objects as a JSON string
String encodeJournalEntries(List<JournalEntry> entries) {
  return jsonEncode(entries.map((entry) => entry.toJson()).toList());
}

// Decode a JSON string to a list of JournalEntry objects
List<JournalEntry> decodeJournalEntries(String jsonString) {
  return (jsonDecode(jsonString) as List<dynamic>)
      .map((item) => JournalEntry.fromJson(item as Map<String, dynamic>))
      .toList();
}

// List<JournalEntry> sampleEntries = [
//   JournalEntry(
//     id: "1",
//     title: "Sunny Day Reflections",
//     body: "Today was exceptionally sunny and bright. I spent some time walking in the park, enjoying the warmth and the vibrant colors around me. It's moments like these that make me feel truly grateful for the simple joys in life.",
//     date: DateTime(2024, 3, 10),
//     mood: "Happy",
//   ),
//   JournalEntry(
//     id: "2",
//     title: "Overcoming Challenges",
//     body: "Faced a tough challenge at work today, but after a lot of effort and collaboration with the team, we managed to find a solution. It reminded me that persistence and teamwork really do pay off in the end.",
//     date: DateTime(2024, 3, 9),
//     mood: "Motivated",
//   ),
//   JournalEntry(
//     id: "3",
//     title: "Quiet Evening Thoughts",
//     body: "The evening was quiet and peaceful, providing a perfect moment for some reflection. I've been thinking a lot about my personal goals and what I want to achieve in the next few months. It's time to start planning and taking action.",
//     date: DateTime(2024, 3, 8),
//     mood: "Reflective",
//   ),
//   JournalEntry(
//     id: "4",
//     title: "A Day of Learning",
//     body: "Attended a workshop today and learned so much about a topic I've been curious about for a while. It's amazing how much there is to learn and how energizing it can be to dive into something new.",
//     date: DateTime(2024, 3, 7),
//     mood: "Inspired",
//   ),
//   JournalEntry(
//     id: "5",
//     title: "Missed Connections",
//     body: "Today was a bit tough. Tried to meet up with a friend, but plans fell through last minute. It's disappointing, but I guess it's just one of those things that happen. Hoping to reconnect soon.",
//     date: DateTime(2024, 3, 6),
//     mood: "Disappointed",
//   ),
// ];
