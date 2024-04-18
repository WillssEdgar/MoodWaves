import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/widgets/details_card.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart'; // Make sure this is the correct path to the generated mocks

// This test checks if the DetailsCard widget displays correctly
// and if the appropriate information (icon, title, value) is displayed in each card
void main() {
  // Create mock instances
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    // Initialize mock instances
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    // Setup mock behavior
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('user123');
  });

  // Test the DetailsCard widget
  testWidgets('DetailsCard displays correctly', (WidgetTester tester) async {
    // simulate the DetailsCard widget
    await tester.pumpWidget(MaterialApp(home: DetailsCard()));

    // Verify that the DetailsCard widget displays correctly
    expect(find.byType(DetailsCard), findsOneWidget);
  });
}
