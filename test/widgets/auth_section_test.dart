import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:art_of_evolve/src/features/account/presentation/widgets/auth_section.dart';
import 'package:art_of_evolve/src/features/auth/presentation/auth_controller.dart';

// Generate a simple mock for AuthController
class MockAuthController extends StateNotifier<AsyncValue<void>>
    with Mock
    implements AuthController {
  MockAuthController() : super(const AsyncData(null));
}

void main() {
  testWidgets('AuthSection shows Sign In/Create Account when not logged in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: AuthSection(isLoggedIn: false)),
        ),
      ),
    );

    expect(find.text('Join the Community'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign Out'), findsNothing);
  });

  testWidgets('AuthSection shows Sign Out button when logged in', (
    WidgetTester tester,
  ) async {
    final mockAuthController = MockAuthController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuthController),
        ],
        child: const MaterialApp(
          home: Scaffold(body: AuthSection(isLoggedIn: true)),
        ),
      ),
    );

    expect(find.text('Sign Out'), findsOneWidget);
    expect(find.text('Join the Community'), findsNothing);
    expect(find.text('Create Account'), findsNothing);
  });

  testWidgets('Tapping Sign Out calls signOut on controller', (
    WidgetTester tester,
  ) async {
    final mockAuthController = MockAuthController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuthController),
        ],
        child: const MaterialApp(
          home: Scaffold(body: AuthSection(isLoggedIn: true)),
        ),
      ),
    );

    await tester.tap(find.text('Sign Out'));
    verify(mockAuthController.signOut()).called(1);
  });
}
