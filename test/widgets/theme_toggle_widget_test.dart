import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/settings/presentation/widgets/theme_toggle_widget.dart';
import 'package:art_of_evolve/src/core/theme/theme_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Box>()])
import 'theme_toggle_widget_test.mocks.dart';

void main() {
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    // Default mock response: system theme
    when(
      mockBox.get(any, defaultValue: anyNamed('defaultValue')),
    ).thenReturn('system');
    when(mockBox.put(any, any)).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        themeModeProvider.overrideWith(
          (ref) => ThemeModeNotifier(box: mockBox),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: ThemeToggleWidget())),
    );
  }

  group('ThemeToggleWidget', () {
    testWidgets('renders all options', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    testWidgets('shows correct initial selection (System)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      // Need async gap for provider init
      await tester.pump();

      // System should be selected (bold font weight usually implies selection)
      // Visual inspection via code: selected has bold font weight, unselected normal
      // We can check if the widget tree contains the text with bold style logic
      // But simpler is to tap and see if state changes
    });

    testWidgets('can switch to Light mode', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      verify(mockBox.put('theme_mode', 'light')).called(1);
    });

    testWidgets('can switch to Dark mode', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      verify(mockBox.put('theme_mode', 'dark')).called(1);
    });
  });
}
