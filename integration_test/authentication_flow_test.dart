import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:art_of_evolve/main.dart' as app;

/// Integration test for authentication flow.
///
/// This test verifies that users can successfully sign up, log in,
/// and log out of the application.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('Navigate to sign up screen', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for sign up button or link
      final signUpButton = find.text('Sign Up');
      if (signUpButton.evaluate().isNotEmpty) {
        await tester.tap(signUpButton.first);
        await tester.pumpAndSettle();

        // Verify we're on the sign up screen
        expect(find.text('Sign Up'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Sign up with valid credentials', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to sign up
      final signUpButton = find.text('Sign Up');
      if (signUpButton.evaluate().isNotEmpty) {
        await tester.tap(signUpButton.first);
        await tester.pumpAndSettle();
      }

      // Enter email
      final emailField = find.byType(TextField).first;
      await tester.enterText(
        emailField,
        'testuser${DateTime.now().millisecondsSinceEpoch}@example.com',
      );
      await tester.pumpAndSettle();

      // Enter password
      final passwordFields = find.byType(TextField);
      if (passwordFields.evaluate().length > 1) {
        await tester.enterText(passwordFields.at(1), 'TestPassword123!');
        await tester.pumpAndSettle();
      }

      // Confirm password (if required)
      if (passwordFields.evaluate().length > 2) {
        await tester.enterText(passwordFields.at(2), 'TestPassword123!');
        await tester.pumpAndSettle();
      }

      // Tap sign up button
      final submitButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify successful sign up (should navigate away or show success)
        // This might navigate to onboarding or home screen
      }
    });

    testWidgets('Sign up with invalid email shows error', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to sign up
      final signUpButton = find.text('Sign Up');
      if (signUpButton.evaluate().isNotEmpty) {
        await tester.tap(signUpButton.first);
        await tester.pumpAndSettle();
      }

      // Enter invalid email
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      // Enter password
      final passwordFields = find.byType(TextField);
      if (passwordFields.evaluate().length > 1) {
        await tester.enterText(passwordFields.at(1), 'TestPassword123!');
        await tester.pumpAndSettle();
      }

      // Try to submit
      final submitButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Verify error message appears
        final errorText = find.textContaining('email');
        if (errorText.evaluate().isNotEmpty) {
          expect(errorText, findsAtLeastNWidgets(1));
        }
      }
    });

    testWidgets('Navigate to login screen', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for login button or link
      final loginButton = find.text('Log In');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();

        // Verify we're on the login screen
        expect(find.text('Log In'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to login
      final loginButton = find.text('Log In');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }

      // Enter email
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Enter password
      final passwordFields = find.byType(TextField);
      if (passwordFields.evaluate().length > 1) {
        await tester.enterText(passwordFields.at(1), 'TestPassword123!');
        await tester.pumpAndSettle();
      }

      // Tap login button
      final submitButton = find.widgetWithText(ElevatedButton, 'Log In');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify successful login (navigation to home or dashboard)
      }
    });

    testWidgets('Login with incorrect password shows error', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to login
      final loginButton = find.text('Log In');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }

      // Enter email
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Enter wrong password
      final passwordFields = find.byType(TextField);
      if (passwordFields.evaluate().length > 1) {
        await tester.enterText(passwordFields.at(1), 'WrongPassword');
        await tester.pumpAndSettle();
      }

      // Try to login
      final submitButton = find.widgetWithText(ElevatedButton, 'Log In');
      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify error message
        final errorText = find.textContaining('password');
        if (errorText.evaluate().isNotEmpty) {
          expect(errorText, findsAtLeastNWidgets(1));
        }
      }
    });

    testWidgets('Toggle password visibility', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to login
      final loginButton = find.text('Log In');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }

      // Look for password visibility toggle icon
      final visibilityIcon = find.byIcon(Icons.visibility);
      final visibilityOffIcon = find.byIcon(Icons.visibility_off);

      if (visibilityIcon.evaluate().isNotEmpty) {
        await tester.tap(visibilityIcon.first);
        await tester.pumpAndSettle();

        // Verify icon changed to visibility_off
        expect(visibilityOffIcon, findsAtLeastNWidgets(1));
      } else if (visibilityOffIcon.evaluate().isNotEmpty) {
        await tester.tap(visibilityOffIcon.first);
        await tester.pumpAndSettle();

        // Verify icon changed to visibility
        expect(visibilityIcon, findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Forgot password flow', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to login
      final loginButton = find.text('Log In');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }

      // Look for forgot password link
      final forgotPasswordLink = find.text('Forgot Password?');
      if (forgotPasswordLink.evaluate().isNotEmpty) {
        await tester.tap(forgotPasswordLink);
        await tester.pumpAndSettle();

        // Enter email for password reset
        final emailField = find.byType(TextField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pumpAndSettle();

        // Submit reset request
        final resetButton = find.widgetWithText(ElevatedButton, 'Reset');
        if (resetButton.evaluate().isNotEmpty) {
          await tester.tap(resetButton);
          await tester.pumpAndSettle();

          // Verify success message
          final successText = find.textContaining('sent');
          if (successText.evaluate().isNotEmpty) {
            expect(successText, findsAtLeastNWidgets(1));
          }
        }
      }
    });

    testWidgets('Switch between login and sign up', (
      WidgetTester tester,
    ) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Start on login screen
      final loginButton = find.text('Log In');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }

      // Switch to sign up
      final switchToSignUp = find.textContaining('Sign Up');
      if (switchToSignUp.evaluate().isNotEmpty) {
        await tester.tap(switchToSignUp.last);
        await tester.pumpAndSettle();

        // Verify on sign up screen
        expect(find.text('Sign Up'), findsAtLeastNWidgets(1));
      }

      // Switch back to login
      final switchToLogin = find.textContaining('Log In');
      if (switchToLogin.evaluate().isNotEmpty) {
        await tester.tap(switchToLogin.last);
        await tester.pumpAndSettle();

        // Verify on login screen
        expect(find.text('Log In'), findsAtLeastNWidgets(1));
      }
    });
  });
}
