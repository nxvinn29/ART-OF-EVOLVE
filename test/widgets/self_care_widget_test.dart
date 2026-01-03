import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/home/presentation/widgets/self_care_widget.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: SelfCareWidget())),
    );
  }

  group('SelfCareWidget', () {
    testWidgets('renders all self-care items correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify header text
      expect(find.text('SELF-CARE'), findsOneWidget);
      expect(
        find.text('FOR WHEN YOU DON\'T HAVE\nTIME TO SPARE'),
        findsOneWidget,
      );

      // Verify grid items presence (checking text presence is enough)
      expect(find.text('do something\nfun-for you!'), findsOneWidget);
      expect(find.text('take a break\nfrom your devices'), findsOneWidget);
      expect(
        find.text('write down\nwhat you\'re\ngrateful for'),
        findsOneWidget,
      );
      expect(find.text('listen to\nsongs that\nuplift you'), findsOneWidget);
      expect(find.text('meditate\neven for just\n5 minutes'), findsOneWidget);
      expect(
        find.text('spend time in nature\n(or look at\nlandscape photos!)'),
        findsOneWidget,
      );
    });

    testWidgets('shows snackbar on "fun" item tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('do something\nfun-for you!'));
      await tester.pump(); // Trigger SnackBar

      expect(find.text('You deserve some fun! Go for it!'), findsOneWidget);
    });

    testWidgets('shows snackbar on "nature" item tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final natureItem = find.text(
        'spend time in nature\n(or look at\nlandscape photos!)',
      );
      await tester.ensureVisible(natureItem);
      await tester.pumpAndSettle();

      await tester.tap(natureItem);
      await tester.pump(); // Trigger SnackBar

      expect(find.text('Take a deep breath and look outside!'), findsOneWidget);
    });

    testWidgets('renders icons correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.sentiment_very_satisfied), findsOneWidget);
      expect(find.byIcon(Icons.phonelink_lock), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.byIcon(Icons.spa), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
    });
  });
}
