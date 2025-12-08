import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_profile.dart';
import '../data/user_repository.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, AsyncValue<void>>((ref) {
      final repository = ref.watch(userRepositoryProvider);
      return OnboardingController(repository);
    });

class OnboardingController extends StateNotifier<AsyncValue<void>> {
  final UserRepository _repository;

  OnboardingController(this._repository) : super(const AsyncData(null));

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
