import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/user_profile.dart';
import '../../../services/storage/hive_service.dart';

/// Provider for accessing the [UserRepository] instance.
///
/// This provider creates and manages a singleton instance of [UserRepository]
/// configured with the Hive user profile box for persistent storage.
///
/// ## Usage:
/// ```dart
/// final repository = ref.watch(userRepositoryProvider);
/// final profile = repository.getUserProfile();
/// ```
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(HiveService.userProfileBox);
});

/// Repository for managing user profile data persistence using Hive.
///
/// This repository provides storage and retrieval operations for [UserProfile]
/// entities, serving as the single source of truth for user data in the application.
/// It implements an offline-first approach with local-only storage.
///
/// ## Features:
/// - Singleton user profile storage
/// - Synchronous profile retrieval
/// - Asynchronous profile updates
/// - Onboarding status management
/// - Automatic data persistence
///
/// ## Usage Example:
/// ```dart
/// final repository = ref.watch(userRepositoryProvider);
///
/// // Retrieve user profile
/// final profile = repository.getUserProfile();
///
/// // Save a new profile
/// final newProfile = UserProfile(
///   name: 'John Doe',
///   wakeTime: DateTime(2024, 1, 1, 7, 0),
///   mood: 'Energetic',
///   primaryGoal: 'Productivity',
/// );
/// await repository.saveUserProfile(newProfile);
///
/// // Update onboarding status
/// await repository.updateOnboardingStatus(true);
/// ```
class UserRepository {
  /// The Hive box instance used for storing the user profile.
  ///
  /// This box is initialized by [HiveService] and contains a single
  /// [UserProfile] object stored with the key 'current_user'.
  final Box<UserProfile> _box;

  /// The key used to store the current user's profile in the Hive box.
  ///
  /// This constant ensures consistent access to the user profile
  /// throughout the application lifecycle.
  static const String _profileKey = 'current_user';

  /// Creates a [UserRepository] with the given Hive [_box].
  ///
  /// The [_box] parameter should be an initialized Hive box configured
  /// to store [UserProfile] objects. Typically obtained from [HiveService.userProfileBox].
  ///
  /// ## Example:
  /// ```dart
  /// final repository = UserRepository(HiveService.userProfileBox);
  /// ```
  UserRepository(this._box);

  /// Retrieves the current user's profile from storage.
  ///
  /// Returns the stored [UserProfile] if it exists, or `null` if no profile
  /// has been saved yet. This is a synchronous operation that reads directly
  /// from the Hive box.
  ///
  /// ## Returns:
  /// The current user's profile, or `null` if no profile exists.
  ///
  /// ## Example:
  /// ```dart
  /// final profile = repository.getUserProfile();
  /// if (profile != null) {
  ///   print('Welcome back, ${profile.name}!');
  /// } else {
  ///   print('No profile found. Please complete onboarding.');
  /// }
  /// ```
  UserProfile? getUserProfile() {
    return _box.get(_profileKey);
  }

  /// Saves or updates the user's profile in storage.
  ///
  /// If a profile already exists, it will be completely replaced with the
  /// new [profile]. The operation is asynchronous and completes when the
  /// data is persisted to disk.
  ///
  /// ## Parameters:
  /// - [profile]: The complete user profile to save. All fields will overwrite
  ///   any existing profile data.
  ///
  /// ## Example:
  /// ```dart
  /// final profile = UserProfile(
  ///   name: 'Jane Smith',
  ///   wakeTime: DateTime(2024, 1, 1, 6, 30),
  ///   mood: 'Focused',
  ///   primaryGoal: 'Health & Wellness',
  ///   hasCompletedOnboarding: true,
  /// );
  /// await repository.saveUserProfile(profile);
  /// ```
  ///
  /// ## Error Handling:
  /// Throws an exception if the Hive box is not open or if there's a disk
  /// write error. Ensure proper error handling in calling code.
  Future<void> saveUserProfile(UserProfile profile) async {
    await _box.put(_profileKey, profile);
  }

  /// Updates only the onboarding completion status of the user's profile.
  ///
  /// This is a convenience method that retrieves the current profile, updates
  /// only the [hasCompletedOnboarding] field, and saves it back. If no profile
  /// exists, this operation does nothing.
  ///
  /// ## Parameters:
  /// - [completed]: The new onboarding completion status. Set to `true` when
  ///   the user completes onboarding, or `false` to reset.
  ///
  /// ## Behavior:
  /// - Preserves all other profile fields unchanged
  /// - Safe to call even if no profile exists (no-op)
  /// - Changes persist immediately to disk
  ///
  /// ## Example:
  /// ```dart
  /// // Mark onboarding as complete
  /// await repository.updateOnboardingStatus(true);
  ///
  /// // Reset onboarding (e.g., for testing)
  /// await repository.updateOnboardingStatus(false);
  /// ```
  ///
  /// ## Note:
  /// This method is typically called after the user completes the onboarding
  /// flow to prevent showing onboarding screens on subsequent app launches.
  Future<void> updateOnboardingStatus(bool completed) async {
    final profile = getUserProfile();
    if (profile != null) {
      final updated = profile.copyWith(hasCompletedOnboarding: completed);
      await saveUserProfile(updated);
    }
  }

  /// Watches for changes to the user profile in real-time.
  ///
  /// Returns a [Stream] that emits the current user profile whenever
  /// it is updated in the Hive box.
  ///
  /// ## Returns:
  /// A stream emitting [UserProfile] objects (or null).
  Stream<UserProfile?> watchUserProfile() {
    return _box
        .watch(key: _profileKey)
        .map((event) => event.value as UserProfile?)
        .startWith(getUserProfile());
  }
}

extension StreamStartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
