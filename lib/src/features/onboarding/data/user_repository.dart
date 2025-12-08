import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/user_profile.dart';
import '../../../services/storage/hive_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(HiveService.userProfileBox);
});

class UserRepository {
  final Box<UserProfile> _box;

  static const String _profileKey = 'current_user';

  UserRepository(this._box);

  UserProfile? getUserProfile() {
    return _box.get(_profileKey);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _box.put(_profileKey, profile);
  }

  Future<void> updateOnboardingStatus(bool completed) async {
    final profile = getUserProfile();
    if (profile != null) {
      final updated = profile.copyWith(hasCompletedOnboarding: completed);
      await saveUserProfile(updated);
    }
  }
}
