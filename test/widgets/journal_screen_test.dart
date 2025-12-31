import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/self_care/presentation/journal_editor_screen.dart';

void main() {
  group('JournalEditorScreen Widget Tests', () {
    testWidgets('journal editor screen renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalEditorScreen())),
      );

      await tester.pumpAndSettle();

      // Verify the screen renders
      expect(find.byType(JournalEditorScreen), findsOneWidget);
    });

    testWidgets('journal editor has proper layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: JournalEditorScreen())),
      );

      await tester.pumpAndSettle();

      // Verify basic UI structure
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
