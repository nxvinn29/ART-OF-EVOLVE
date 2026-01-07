import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/presentation/animated_checkbox.dart';

void main() {
  group('AnimatedCheckbox Widget Tests', () {
    testWidgets('renders accurately with initial value false', (
      WidgetTester tester,
    ) async {
      var value = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCheckbox(
              value: value,
              onChanged: (newValue) {
                value = newValue;
              },
            ),
          ),
        ),
      );

      // Checkbox container exists
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      // Icon should not be visible or have 0 opacity/scale initially if false.
      // Implementation details: it uses FadeTransition/ScaleTransition.
      // But we can check color of container border/fill.

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);
      expect((decoration.border as Border).top.color, Colors.grey.shade400);
    });

    testWidgets('renders accurately with initial value true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCheckbox(
              value: true,
              onChanged: (_) {},
              activeColor: Colors.purple,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.purple);
    });

    testWidgets('calls onChanged when tapped', (WidgetTester tester) async {
      bool? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCheckbox(
              value: false,
              onChanged: (newValue) {
                changedValue = newValue;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AnimatedCheckbox));
      await tester.pumpAndSettle();

      expect(changedValue, true);
    });

    testWidgets('toggles visual state', (WidgetTester tester) async {
      // visual state depends on the "value" prop passed down.
      // The widget is stateless in regards to logic, but has internal state for animation.
      // IF the parent doesn't update, the widget might animate?
      // The code says: didUpdateWidget -> forward/reverse.
      // So parent MUST update value for animation to happen.

      var value = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimatedCheckbox(
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      value = newValue;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially unchecked
      expect(
        (tester.widget<Container>(find.byType(Container)).decoration
                as BoxDecoration)
            .color,
        Colors.transparent,
      );

      // Tap
      await tester.tap(find.byType(AnimatedCheckbox));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 300)); // Finish animation

      // Now checked
      expect(
        (tester.widget<Container>(find.byType(Container)).decoration
                as BoxDecoration)
            .color,
        Colors.green, // default activeColor
      );

      // Tap again
      await tester.tap(find.byType(AnimatedCheckbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Now unchecked
      expect(
        (tester.widget<Container>(find.byType(Container)).decoration
                as BoxDecoration)
            .color,
        Colors.transparent,
      );
    });
  });
}
