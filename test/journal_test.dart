import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mood_waves/classes/journal_entry_class.dart';
import 'package:mood_waves/screens/journal.dart';
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
    testWidgets("Journal Test", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: JournalPage(),
      ));

      expect(find.byType(JournalPage), findsOneWidget);
    });

    testWidgets("Journal Second Test", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: JournalPage(),
      ));

      expect(find.text("Journal"), findsOneWidget);

      expect(find.byType(JournalPage), findsOneWidget);
    });

    test('Journal Entry Class Test', () {
      final journal_entry = JournalEntry(
          id: '123', title: 'title', body: 'body', date: DateTime.now());
      expect(journal_entry.id, equals("123"));
      expect(journal_entry.title, equals("title"));
      expect(journal_entry.body, equals("body"));

      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormat.format(journal_entry.date);

      expect(formattedDate, equals(dateFormat.format(DateTime.now())));
    });
  });
}
