import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/features/auth/presentation/auth_controller.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>(), MockSpec<UserCredential>()])
import 'auth_controller_test.mocks.dart';

void main() {
  late AuthController authController;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authController = AuthController(mockAuth);
  });

  group('AuthController', () {
    test('initial state is AsyncData(null)', () {
      expect(authController.debugState, const AsyncData<void>(null));
    });

    group('signIn', () {
      test('signs in successfully', () async {
        // Arrange
        when(
          mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).thenAnswer((_) async => MockUserCredential());

        // Act
        await authController.signIn('test@example.com', 'password');

        // Assert
        verify(
          mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).called(1);
        expect(authController.debugState, const AsyncData<void>(null));
      });

      test('sets state to AsyncError on failure', () async {
        // Arrange
        final exception = FirebaseAuthException(code: 'user-not-found');
        when(
          mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).thenThrow(exception);

        // Act
        await authController.signIn('test@example.com', 'password');

        // Assert
        expect(authController.debugState, isA<AsyncError>());
      });
    });

    group('signUp', () {
      test('signs up successfully', () async {
        // Arrange
        when(
          mockAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password',
          ),
        ).thenAnswer((_) async => MockUserCredential());

        // Act
        await authController.signUp('new@example.com', 'password');

        // Assert
        verify(
          mockAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password',
          ),
        ).called(1);
        expect(authController.debugState, const AsyncData<void>(null));
      });

      test('sets state to AsyncError on failure', () async {
        // Arrange
        final exception = FirebaseAuthException(code: 'email-already-in-use');
        when(
          mockAuth.createUserWithEmailAndPassword(
            email: 'new@example.com',
            password: 'password',
          ),
        ).thenThrow(exception);

        // Act
        await authController.signUp('new@example.com', 'password');

        // Assert
        expect(authController.debugState, isA<AsyncError>());
      });
    });

    group('signOut', () {
      test('signs out successfully', () async {
        // Act
        await authController.signOut();

        // Assert
        verify(mockAuth.signOut()).called(1);
        expect(authController.debugState, const AsyncData<void>(null));
      });
    });

    group('sendPasswordResetEmail', () {
      test('sends password reset email', () async {
        // Act
        await authController.sendPasswordResetEmail('test@example.com');

        // Assert
        verify(
          mockAuth.sendPasswordResetEmail(email: 'test@example.com'),
        ).called(1);
      });
    });
  });
}
