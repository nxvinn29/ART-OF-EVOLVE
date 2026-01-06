import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/account/presentation/widgets/profile_header.dart';

void main() {
  testWidgets('ProfileHeader renders correct name and initial', (
    WidgetTester tester,
  ) async {
    const name = 'Naveen';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ProfileHeader(name: name)),
      ),
    );

    expect(find.text(name), findsOneWidget);
    expect(find.text('N'), findsOneWidget); // Initial
    expect(find.text('Keep evolving!'), findsOneWidget);
  });

  testWidgets('ProfileHeader handles empty name gracefully', (
    WidgetTester tester,
  ) async {
    const name = '';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ProfileHeader(name: name)),
      ),
    );

    expect(find.text('A'), findsOneWidget); // Default initial 'A'
  });
}
