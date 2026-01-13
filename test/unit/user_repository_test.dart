import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:art_of_evolve/src/features/onboarding/data/user_repository.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';

// Manual mock for Hive Box since Mockito can't mock the [] operator properly
class MockBox<T> extends Fake implements Box<T> {
  final Map<dynamic, T> _data = {};

  @override
  T? get(dynamic key, {T? defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<void> put(dynamic key, T value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key);
  }

  @override
  Iterable<T> get values => _data.values;
}

void main() {
  late MockBox<UserProfile> mockBox;
  late UserRepository repository;

  setUp(() {
    mockBox = MockBox<UserProfile>();
    repository = UserRepository(mockBox);
  });

  group('UserRepository', () {
    test('getUserProfile returns null when no profile exists', () {
      // Act
      final result = repository.getUserProfile();

      // Assert
      expect(result, isNull);
    });

    test('getUserProfile returns profile when it exists', () async {
      // Arrange
      final profile = UserProfile(
        name: 'Test User',
        wakeTime: DateTime(2024, 1, 1, 7, 0),
        mood: 'Happy',
        primaryGoal: 'Productivity',
      );
      await repository.saveUserProfile(profile);

      // Act
      final result = repository.getUserProfile();

      // Assert
      expect(result, isNotNull);
      expect(result?.name, 'Test User');
      expect(result?.mood, 'Happy');
      expect(result?.primaryGoal, 'Productivity');
    });

    test('saveUserProfile successfully saves a profile', () async {
      // Arrange
      final profile = UserProfile(
        name: 'John Doe',
        wakeTime: DateTime(2024, 1, 1, 6, 30),
        mood: 'Energetic',
        primaryGoal: 'Fitness',
      );

      // Act
      await repository.saveUserProfile(profile);
      final saved = repository.getUserProfile();

      // Assert
      expect(saved, isNotNull);
      expect(saved?.name, 'John Doe');
      expect(saved?.mood, 'Energetic');
      expect(saved?.primaryGoal, 'Fitness');
    });

    test('saveUserProfile overwrites existing profile', () async {
      // Arrange
      final oldProfile = UserProfile(
        name: 'Old Name',
        wakeTime: DateTime(2024, 1, 1, 8, 0),
        mood: 'Tired',
        primaryGoal: 'Rest',
      );
      final newProfile = UserProfile(
        name: 'New Name',
        wakeTime: DateTime(2024, 1, 1, 6, 0),
        mood: 'Fresh',
        primaryGoal: 'Work',
      );

      // Act
      await repository.saveUserProfile(oldProfile);
      await repository.saveUserProfile(newProfile);
      final result = repository.getUserProfile();

      // Assert
      expect(result?.name, 'New Name');
      expect(result?.mood, 'Fresh');
      expect(result?.primaryGoal, 'Work');
    });

    test('updateOnboardingStatus updates existing profile correctly', () async {
      // Arrange
      final profile = UserProfile(
        name: 'Test User',
        wakeTime: DateTime(2024, 1, 1, 7, 0),
        mood: 'Happy',
        primaryGoal: 'Growth',
        hasCompletedOnboarding: false,
      );
      await repository.saveUserProfile(profile);

      // Act
      await repository.updateOnboardingStatus(true);
      final updated = repository.getUserProfile();

      // Assert
      expect(updated, isNotNull);
      expect(updated?.name, 'Test User');
      expect(updated?.mood, 'Happy');
      expect(updated?.primaryGoal, 'Growth');
      expect(updated?.hasCompletedOnboarding, true);
    });

    test('updateOnboardingStatus does nothing when profile is null', () async {
      // Act
      await repository.updateOnboardingStatus(true);
      final result = repository.getUserProfile();

      // Assert
      expect(result, isNull);
    });

    test('updateOnboardingStatus can set status to false', () async {
      // Arrange
      final profile = UserProfile(
        name: 'Test User',
        wakeTime: DateTime(2024, 1, 1, 7, 0),
        mood: 'Neutral',
        primaryGoal: 'Learning',
        hasCompletedOnboarding: true,
      );
      await repository.saveUserProfile(profile);

      // Act
      await repository.updateOnboardingStatus(false);
      final updated = repository.getUserProfile();

      // Assert
      expect(updated?.hasCompletedOnboarding, false);
    });

    test('saveUserProfile preserves profile ID', () async {
      // Arrange
      final profile = UserProfile(
        name: 'ID Test',
        wakeTime: DateTime(2024, 1, 1, 9, 0),
        mood: 'Focused',
        primaryGoal: 'Testing',
      );
      final originalId = profile.id;

      // Act
      await repository.saveUserProfile(profile);
      final saved = repository.getUserProfile();

      // Assert
      expect(saved?.id, originalId);
    });

    test('multiple save operations maintain data integrity', () async {
      // Arrange & Act
      for (int i = 0; i < 5; i++) {
        final profile = UserProfile(
          name: 'User $i',
          wakeTime: DateTime(2024, 1, 1, 7 + i, 0),
          mood: 'Mood $i',
          primaryGoal: 'Goal $i',
        );
        await repository.saveUserProfile(profile);
      }

      final result = repository.getUserProfile();

      // Assert - should have the last saved profile
      expect(result?.name, 'User 4');
      expect(result?.mood, 'Mood 4');
      expect(result?.primaryGoal, 'Goal 4');
    });
  });
}
