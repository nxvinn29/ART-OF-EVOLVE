import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_screen.dart';

void main() {
  group('JournalScreen Widget Tests', () {
    testWidgets('journal screen renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalScreen())),
      );

      await tester.pumpAndSettle();

      // Verify the screen renders
      expect(find.byType(JournalScreen), findsOneWidget);
    });

    testWidgets('add entry button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalScreen())),
      );

      await tester.pumpAndSettle();

      // Check for FloatingActionButton or add button
      expect(
        find.byType(FloatingActionButton).evaluate().isNotEmpty ||
            find.byIcon(Icons.add).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('journal screen has proper layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalScreen())),
      );

      await tester.pumpAndSettle();

      // Verify basic UI structure
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
