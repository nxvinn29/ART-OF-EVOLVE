import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';

void main() {
  group('UserProfile Tests', () {
    test('supports value equality', () {
      final now = DateTime.now();
      final user1 = UserProfile(
        id: '1',
        name: 'Test',
        wakeTime: now,
        mood: 'Happy',
        primaryGoal: 'Code',
        hasCompletedOnboarding: true,
      );
      final user2 = UserProfile(
        id: '1',
        name: 'Test',
        wakeTime: now,
        mood: 'Happy',
        primaryGoal: 'Code',
        hasCompletedOnboarding: true,
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('copyWith creates new instance with updated values', () {
      final user = UserProfile(name: 'Test', wakeTime: DateTime.now());

      final updated = user.copyWith(name: 'Updated Name');

      expect(updated.name, equals('Updated Name'));
      expect(updated.wakeTime, equals(user.wakeTime));
      // IDs should match since copyWith preserves ID
      expect(updated.id, equals(user.id));
    });

    test('toString contains relevant info', () {
      final user = UserProfile(
        id: '123',
        name: 'Test User',
        wakeTime: DateTime(2023, 1, 1),
      );

      expect(user.toString(), contains('Test User'));
      expect(user.toString(), contains('123'));
    });
  });
}
