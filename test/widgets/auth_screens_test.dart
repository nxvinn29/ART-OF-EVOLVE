import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:art_of_evolve/src/features/auth/presentation/auth_screens.dart';

void main() {
  testWidgets('SignInScreen builds correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SignInScreen())),
    );

    // Verify that title is present
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);

    // Verify text fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify buttons
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('SignUpScreen builds correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SignUpScreen())),
    );

    // Verify that title is present
    expect(find.text('Join the Journey'), findsOneWidget);
    expect(find.text('Create an account to start evolving'), findsOneWidget);

    // Verify text fields
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify button
    expect(find.text('Create Account'), findsOneWidget);
  });
}
