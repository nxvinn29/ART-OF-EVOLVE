import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the current authentication state of the user.
///
/// Returns a [User] object if signed in, or null otherwise.
final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Controller for managing authentication-related operations.
///
/// This controller handles signing in, signing up, signing out, and password resets
/// using [FirebaseAuth]. It manages the state as an [AsyncValue] to reflect
/// loading, success, and error states.
class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController() : super(const AsyncData(null));

  /// Signs in a user with the provided [email] and [password].
  ///
  /// Updates the state to [AsyncLoading] during the process, and then to
  /// [AsyncData] on success or [AsyncError] on failure.
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Creates a new user account with the provided [email] and [password].
  ///
  /// Updates the state to [AsyncLoading] during the process, and then to
  /// [AsyncData] on success or [AsyncError] on failure.
  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Signs out the current user.
  ///
  /// Updates the state to [AsyncLoading] during the process.
  Future<void> signOut() async {
    state = const AsyncLoading();
    // Wrap in guard or try/catch, though guard is safer for async value
    state = await AsyncValue.guard(() => FirebaseAuth.instance.signOut());
  }

  /// Sends a password reset email to the provided [email] address.
  Future<void> sendPasswordResetEmail(String email) async {
    // No state loading needed for this usually, but can double check
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

/// Provider for the [AuthController].
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      return AuthController();
    });
