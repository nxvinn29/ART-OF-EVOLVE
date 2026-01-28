import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:art_of_evolve/src/features/onboarding/presentation/user_provider.dart';
import 'package:art_of_evolve/src/features/onboarding/data/user_repository.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'user_provider_test.mocks.dart';

void main() {
  late MockUserRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(mockRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('UserNotifier', () {
    final testUser = UserProfile(
      id: '123',
      name: 'Test User',
      wakeTime: DateTime(2023, 1, 1, 8, 0),
      hasCompletedOnboarding: true,
    );

    test('initial state should be null if repository returns null', () {
      when(mockRepository.getUserProfile()).thenReturn(null);

      final state = container.read(userProvider);

      expect(state, isNull);
      verify(mockRepository.getUserProfile()).called(1);
    });

    test(
      'initial state should be user profile if repository returns profile',
      () {
        when(mockRepository.getUserProfile()).thenReturn(testUser);

        final state = container.read(userProvider);

        expect(state, equals(testUser));
        verify(mockRepository.getUserProfile()).called(1);
      },
    );

    test('refresh should update state from repository', () async {
      // Initial state null
      when(mockRepository.getUserProfile()).thenReturn(null);
      expect(container.read(userProvider), isNull);

      // Update repository to return user
      when(mockRepository.getUserProfile()).thenReturn(testUser);

      // Call refresh
      await container.read(userProvider.notifier).refresh();

      expect(container.read(userProvider), equals(testUser));
      verify(mockRepository.getUserProfile()).called(2);
    });
  });
}
