import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/self_care_widget.dart';

void main() {
  testWidgets('SelfCareWidget renders title and grid items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SelfCareWidget())),
    );

    // Verify Title
    expect(find.text('SELF-CARE'), findsOneWidget);
    expect(find.text("FOR WHEN YOU DON'T HAVE\nTIME TO SPARE"), findsOneWidget);

    // Verify some grid items
    expect(find.text('do something\nfun-for you!'), findsOneWidget);
    expect(find.text('take a break\nfrom your devices'), findsOneWidget);
    expect(find.text('write down\nwhat you\'re\ngrateful for'), findsOneWidget);

    // Check for icons
    expect(find.byIcon(Icons.sentiment_very_satisfied), findsOneWidget);
    expect(find.byIcon(Icons.phonelink_lock), findsOneWidget);
  });

  testWidgets('Tapping fun item shows snackbar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SelfCareWidget())),
    );

    await tester.tap(find.text('do something\nfun-for you!'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 500)); // Finish animation

    expect(find.text('You deserve some fun! Go for it!'), findsOneWidget);
  });

  testWidgets('Tapping nature item shows snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SelfCareWidget())),
    );

    // Scroll if necessary (it's in a gridview that shrinks wrap but might need scrolling if screen small)
    // The widget is in a Column, but GridView is shrinkWrap=true.
    // However, the test surface is 800x600 usually, might fit.
    // If not, we ensure visibility.
    final natureItemFinder = find.text(
      'spend time in nature\n(or look at\nlandscape photos!)',
    );
    await tester.ensureVisible(natureItemFinder);
    await tester.pumpAndSettle();

    await tester.tap(natureItemFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Take a deep breath and look outside!'), findsOneWidget);
  });
}
