import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Common button smoke test', (WidgetTester tester) async {
    // Tests a standard ElevatedButton to ensure theme/widget tree health
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {},
            child: const Text('Test Button'),
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Common input field smoke test', (WidgetTester tester) async {
    // Tests a standard TextField
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(decoration: InputDecoration(labelText: 'Enter text')),
        ),
      ),
    );

    expect(find.text('Enter text'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
  });
}
