/// Creates a event object for every event
/// 
/// Is meant to scan WaveLink for events
class MentalHealthEvent {
  String name;
  DateTime date;
  String description;

  MentalHealthEvent(this.name, this.date, this.description);
}

var sampleEvents = [
  MentalHealthEvent("Therapy", DateTime.now(), "Therapy with Dr. Smith"),
  MentalHealthEvent(
      "Group Therapy", DateTime.now(), "Group therapy with Dr. Smith"),
  MentalHealthEvent("Medication", DateTime.now(), "Take medication"),
  MentalHealthEvent("Exercise", DateTime.now(), "Go for a walk"),
  MentalHealthEvent("Meditation", DateTime.now(), "Meditate for 10 minutes"),
  MentalHealthEvent("Journaling", DateTime.now(), "Write in journal"),
  MentalHealthEvent("Sleep", DateTime.now(), "Get 8 hours of sleep"),
  MentalHealthEvent("Socialize", DateTime.now(), "Call a friend"),
  MentalHealthEvent("Eat", DateTime.now(), "Eat a healthy meal"),
  MentalHealthEvent("Hydrate", DateTime.now(), "Drink water"),
];
