import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen builds and navigates correctly', (
    WidgetTester tester,
  ) async {
    // We wrap HomeScreen in a ProviderScope and MaterialApp
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    // Verify AppBar title
    expect(find.text('My Daily Journey'), findsOneWidget);

    // Verify NavigationBar is present
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify destinations
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('To-Dos'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Self Care'), findsOneWidget);

    // Verify initial page (Habits/Dashboard)
    // Note: Since DashboardView might be complex, we just check if IndexedStack is present
    expect(find.byType(IndexedStack), findsOneWidget);

    // Test navigation
    await tester.tap(find.text('Goals'));
    await tester.pumpAndSettle();

    // Verify state change (although visually it's just index change, we verify no crash)
  });
}
