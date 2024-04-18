import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_waves/widgets/details_card.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart'; // Make sure this is the correct path to the generated mocks

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    // Setup mock behavior
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('user123');
  });

  testWidgets('DetailsCard displays correctly', (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(MaterialApp(home: DetailsCard()));

    // Assert
    expect(find.byType(DetailsCard), findsOneWidget);
  });
}
