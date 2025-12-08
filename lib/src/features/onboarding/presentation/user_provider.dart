import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_profile.dart';
import '../data/user_repository.dart';

final userProvider = NotifierProvider<UserNotifier, UserProfile?>(
  UserNotifier.new,
);

class UserNotifier extends Notifier<UserProfile?> {
  late final UserRepository _repository;

  @override
  UserProfile? build() {
    _repository = ref.watch(userRepositoryProvider);
    return _repository.getUserProfile();
  }

  Future<void> refresh() async {
    state = _repository.getUserProfile();
  }
}
