# Testing Strategy - Art of Evolve

## Overview
This document outlines the comprehensive testing strategy for the Art of Evolve application, including unit tests, widget tests, and integration tests.

## Test Structure

### Directory Organization
```
test/
├── unit/              # Unit tests for models and business logic
├── widgets/           # Widget tests for UI components
├── integration_test/  # End-to-end integration tests
├── helpers/           # Test utilities and mocks
└── README.md          # This file
```

## Testing Levels

### 1. Unit Tests (`test/unit/`)
Unit tests focus on testing individual components in isolation.

**Coverage Areas:**
- **Models**: Goal, Todo, Habit, JournalEntry
- **Services**: NotificationService, FirebaseAuthService, DataSyncService
- **Utilities**: Date helpers, streak calculators, validators
- **Business Logic**: XP calculations, level progression, achievement unlocking

**Best Practices:**
- Test one thing at a time
- Use descriptive test names
- Cover edge cases and error conditions
- Mock external dependencies
- Aim for high code coverage (>80%)

**Example:**
```dart
test('creates goal with all required fields', () {
  final goal = Goal(
    title: 'Learn Flutter',
    targetDate: DateTime(2026, 12, 31),
  );
  
  expect(goal.title, 'Learn Flutter');
  expect(goal.isAchieved, false);
});
```

### 2. Widget Tests (`test/widgets/`)
Widget tests verify UI components render correctly and handle user interactions.

**Coverage Areas:**
- **Screens**: HomeScreen, GoalsScreen, HabitsScreen, SettingsScreen
- **Components**: GoalCard, HabitCard, TodoListWidget, StatisticsChart
- **Common Widgets**: Buttons, dialogs, progress bars

**Best Practices:**
- Test widget rendering
- Verify user interactions (taps, swipes, input)
- Test different widget states (loading, error, empty)
- Use `pumpWidget` and `pumpAndSettle` appropriately
- Test accessibility features

**Example:**
```dart
testWidgets('displays goal title', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: GoalCard(goal: testGoal),
    ),
  );
  
  expect(find.text('Learn Flutter'), findsOneWidget);
});
```

### 3. Integration Tests (`integration_test/`)
Integration tests verify complete user flows and feature interactions.

**Coverage Areas:**
- **User Flows**: Onboarding, authentication, habit tracking
- **Feature Integration**: Goal achievement, statistics visualization
- **Cross-Feature**: Navigation, data persistence, state management

**Best Practices:**
- Test realistic user scenarios
- Verify data persistence
- Test navigation flows
- Handle asynchronous operations
- Test on real devices when possible

**Example:**
```dart
testWidgets('complete onboarding flow', (WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle();
  
  // Enter name
  await tester.enterText(find.byType(TextField), 'Test User');
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.text('Welcome'), findsNothing);
});
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/goal_model_test.dart
```

### Run Widget Tests Only
```bash
flutter test test/widgets/
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Run with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Test Utilities

### Mocks and Fakes
Located in `test/helpers/`, these provide mock implementations for:
- Repository interfaces
- External services
- Platform-specific APIs

### Test Data
Use consistent test data across tests:
```dart
final testGoal = Goal(
  title: 'Test Goal',
  targetDate: DateTime(2026, 12, 31),
);
```

## Continuous Integration

### GitHub Actions
Tests run automatically on:
- Pull requests
- Pushes to main branch
- Scheduled daily runs

### Quality Gates
- All tests must pass
- Code coverage must be >75%
- No new lint warnings

## Best Practices Summary

1. **Write Tests First**: Consider TDD for new features
2. **Keep Tests Fast**: Unit tests should run in milliseconds
3. **Isolate Tests**: Each test should be independent
4. **Use Descriptive Names**: Test names should explain what they test
5. **Test Edge Cases**: Don't just test the happy path
6. **Mock External Dependencies**: Keep tests deterministic
7. **Maintain Tests**: Update tests when code changes
8. **Review Coverage**: Regularly check and improve coverage

## Common Patterns

### Testing Async Code
```dart
test('loads data asynchronously', () async {
  final result = await repository.fetchData();
  expect(result, isNotEmpty);
});
```

### Testing Streams
```dart
test('emits state changes', () {
  expectLater(
    controller.stream,
    emitsInOrder([State.loading, State.loaded]),
  );
});
```

### Testing Errors
```dart
test('throws exception on invalid input', () {
  expect(
    () => service.process(null),
    throwsA(isA<ArgumentError>()),
  );
});
```

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Widget Testing Guide](https://flutter.dev/docs/cookbook/testing/widget/introduction)
- [Integration Testing Guide](https://flutter.dev/docs/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

## Contributing

When adding new features:
1. Write tests for new code
2. Update existing tests if behavior changes
3. Ensure all tests pass before submitting PR
4. Add test documentation for complex scenarios

## Maintenance

- Review and update tests quarterly
- Remove obsolete tests
- Refactor duplicate test code
- Keep test dependencies up to date
