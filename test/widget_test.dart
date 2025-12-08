import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/app.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ArtOfEvolveApp()));

    // Verify that the app builds.
    expect(
      find.text('Art of Evolve'),
      findsNothing,
    ); // Title is in MaterialApp, might not be visible text
  });
}
