import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mood_waves/classes/journal_entry_class.dart';
import 'package:mood_waves/screens/journal_entry.dart';
import 'mock.dart';

@GenerateMocks([FirebaseAuth, FirebaseFirestore])
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  // Set up a mock Firebase app

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Journal Tests', () {
    testWidgets("Journal Entry Test", (WidgetTester tester) async {
      final journal_entry = JournalEntry(
          id: '123', title: 'title', body: 'body', date: DateTime.now());

      await tester.pumpWidget(MaterialApp(
        home: JournalEntryEditScreen(
          entry: journal_entry,
          onSave: (JournalEntry) {},
        ),
      ));

      expect(find.byType(JournalEntryEditScreen), findsOneWidget);
    });

    testWidgets("Journal Entry Test", (WidgetTester tester) async {
      final journal_entry = JournalEntry(
          id: '123', title: 'title', body: 'body', date: DateTime.now());

      await tester.pumpWidget(MaterialApp(
        home: JournalEntryEditScreen(
          entry: journal_entry,
          onSave: (JournalEntry) {},
        ),
      ));

      expect(find.text("Title"), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
      expect(find.text("Body"), findsOneWidget);

      expect(find.byType(JournalEntryEditScreen), findsOneWidget);
    });
  });
}
