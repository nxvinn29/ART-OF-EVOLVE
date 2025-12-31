import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/settings/presentation/settings_screen.dart';

void main() {
  group('SettingsScreen Widget Tests', () {
    testWidgets('settings screen renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      await tester.pumpAndSettle();

      // Verify the screen renders
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('settings screen has proper layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      await tester.pumpAndSettle();

      // Verify basic UI structure
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('settings options are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SettingsScreen())),
      );

      await tester.pumpAndSettle();

      // Check for list tiles or settings widgets
      expect(
        find.byType(ListTile).evaluate().isNotEmpty ||
            find.byType(SwitchListTile).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
}
