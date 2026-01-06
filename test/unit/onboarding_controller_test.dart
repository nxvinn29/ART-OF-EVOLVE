import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/features/onboarding/data/user_repository.dart';
import 'package:art_of_evolve/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:art_of_evolve/src/features/onboarding/domain/user_profile.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'onboarding_controller_test.mocks.dart';

void main() {
  late MockUserRepository mockRepository;
  late OnboardingController controller;

  setUp(() {
    mockRepository = MockUserRepository();
    controller = OnboardingController(mockRepository);
  });

  group('OnboardingController', () {
    test('completeOnboarding saves profile and updates state', () async {
      when(mockRepository.saveUserProfile(any)).thenAnswer((_) async {});

      const wakeTime = TimeOfDay(hour: 7, minute: 0);
      await controller.completeOnboarding(
        name: 'Test User',
        wakeTime: wakeTime,
        mood: 'Happy',
        primaryGoal: 'Productivity',
      );

      // Verify repository call
      verify(
        mockRepository.saveUserProfile(
          argThat(
            predicate<UserProfile>(
              (p) =>
                  p.name == 'Test User' &&
                  p.mood == 'Happy' &&
                  p.primaryGoal == 'Productivity' &&
                  p.hasCompletedOnboarding == true,
            ),
          ),
        ),
      ).called(1);

      // Verify state is AsyncData (success)
      expect(controller.state, isA<AsyncData>());
      expect(controller.state.hasError, false);
    });

    test('completeOnboarding handles errors', () async {
      when(
        mockRepository.saveUserProfile(any),
      ).thenThrow(Exception('Save failed'));

      const wakeTime = TimeOfDay(hour: 7, minute: 0);
      await controller.completeOnboarding(
        name: 'Test',
        wakeTime: wakeTime,
        mood: 'Sad',
        primaryGoal: 'Rest',
      );

      expect(controller.state, isA<AsyncError>());
    });
  });
}
