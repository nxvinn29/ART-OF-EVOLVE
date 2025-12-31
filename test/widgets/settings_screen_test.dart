import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/account/presentation/account_screen.dart';

void main() {
  group('AccountScreen Widget Tests', () {
    testWidgets('account screen renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AccountScreen())),
      );

      await tester.pumpAndSettle();

      // Verify the screen renders
      expect(find.byType(AccountScreen), findsOneWidget);
    });

    testWidgets('account screen has proper layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AccountScreen())),
      );

      await tester.pumpAndSettle();

      // Verify basic UI structure
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('account options are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AccountScreen())),
      );

      await tester.pumpAndSettle();

      // Check for list tiles or account widgets
      expect(
        find.byType(ListTile).evaluate().isNotEmpty ||
            find.byType(Card).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
}
