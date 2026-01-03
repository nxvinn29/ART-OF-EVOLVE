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
/// This StateNotifier handles the entire authentication lifecycle including:
/// - Signing in via [signIn]
/// - Signing up via [signUp]
/// - Signing out via [signOut]
/// - Password resets via [sendPasswordResetEmail]
///
/// State management is handled through [AsyncValue] to seamlessly provide
/// loading, error, and success states to the UI.
class AuthController extends StateNotifier<AsyncValue<void>> {
  final FirebaseAuth _auth;

  AuthController(this._auth) : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _auth.signOut());
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      return AuthController(FirebaseAuth.instance);
    });
