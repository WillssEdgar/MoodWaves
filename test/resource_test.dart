import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/screens/resources.dart';
import 'mocks.dart';


void main() {
  // Set up a mock Firebase app

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // Set up mock instances for FirebaseAuth and Firestore

  group('SearchBarTests', () {

    testWidgets("Resources Page Found", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
      home: ResourcesPage(),
      ));
    expect(find.byType(ResourcesPage), findsOneWidget);
    });


    /// Issue #14, brings an item to the top of the page
    testWidgets("Search Bar Empty", (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(
      home: ResourcesPage(),
    ));

    final searchBarFinder = find.byType(SearchBarChangeListener);
    expect(find.text('Search...'), findsOneWidget);

    });


  });


}
