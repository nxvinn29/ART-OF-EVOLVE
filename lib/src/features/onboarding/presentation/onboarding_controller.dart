import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_profile.dart';
import '../data/user_repository.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, AsyncValue<void>>((ref) {
      final repository = ref.watch(userRepositoryProvider);
      return OnboardingController(repository);
    });

/// Controller for the onboarding flow.
///
/// Manages state transitions and user data persistence during the onboarding process.
class OnboardingController extends StateNotifier<AsyncValue<void>> {
  final UserRepository _repository;

  /// Creates a new [OnboardingController].
  ///
  /// Requires a [UserRepository] to save profile data.
  OnboardingController(this._repository) : super(const AsyncData(null));

  /// Completes the onboarding process by saving the user profile.
  ///
  /// This method:
  /// 1. Sets the state to [AsyncLoading].
  /// 2. Creates a [UserProfile] entity from the provided data.
  /// 3. Persists the profile using the [_repository].
  /// 4. Updates the state to [AsyncData] on success or [AsyncError] on failure.
  ///
  /// Parameters:
  /// - [name]: The user's full name or nickname.
  /// - [wakeTime]: The user's preferred daily wake-up time.
  /// - [mood]: The user's current mood or emotional state.
  /// - [primaryGoal]: The main objective the user wants to achieve.
  Future<void> completeOnboarding({
    required String name,
    required TimeOfDay wakeTime,
    required String mood,
    required String primaryGoal,
  }) async {
    state = const AsyncLoading();
    try {
      final now = DateTime.now();
      final wakeDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        wakeTime.hour,
        wakeTime.minute,
      );

      final profile = UserProfile(
        name: name,
        wakeTime: wakeDateTime,
        mood: mood,
        primaryGoal: primaryGoal,
        hasCompletedOnboarding: true,
      );

      await _repository.saveUserProfile(profile);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
