import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:art_of_evolve/src/app.dart';
import 'package:art_of_evolve/src/features/onboarding/data/user_repository.dart';
import 'package:art_of_evolve/src/features/gamification/presentation/gamification_controller.dart';
import 'package:art_of_evolve/src/core/theme/theme_controller.dart';
import 'package:hive/hive.dart';

@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<Box>()])
import 'app_test.mocks.dart';

void main() {
  testWidgets('App should render MaterialApp', (tester) async {
    Hive.init('.');
    final mockUserRepository = MockUserRepository();

    // Stub UserRepository
    when(mockUserRepository.getUserProfile()).thenReturn(null);
    when(
      mockUserRepository.watchUserProfile(),
    ).thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockUserRepository),
          gamificationControllerProvider.overrideWith(
            (ref) => _ManualMockGamificationController(),
          ),
          themeModeProvider.overrideWith(
            (ref) => _ManualMockThemeModeNotifier(),
          ),
        ],
        child: const ArtOfEvolveApp(),
      ),
    );

    // Only verify that MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

class _ManualMockGamificationController extends GamificationController {
  _ManualMockGamificationController() : super();
}

class _ManualMockThemeModeNotifier extends ThemeModeNotifier {
  _ManualMockThemeModeNotifier() : super(box: null);

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
  }
}
