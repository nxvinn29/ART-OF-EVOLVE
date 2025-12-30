# 🧪 Tests

This directory contains unit and widget tests for the **Art of Evolve** application.

## 📂 Structure

- `unit/`: Unit tests for models, utilities, and business logic
  - `habit_test.dart`: Tests for Habit model and streak calculations
  - `badge_test.dart`: Tests for Badge model and predefined badges
  - `user_stats_test.dart`: Tests for UserStats and XP progression
  - `journal_entry_test.dart`: Tests for JournalEntry model
  - `datetime_helpers_test.dart`: Tests for date/time utility functions
- `widgets/`: Widget tests for UI components
  - `badge_showcase_widget_test.dart`: Tests for badge display widget
  - `level_progress_bar_test.dart`: Tests for level progress indicator
  - `auth_screens_test.dart`: Tests for authentication screens
  - `home_screen_test.dart`: Tests for home screen
  - `common_widgets_test.dart`: Tests for reusable widgets
- `features/`: Feature-specific integration tests
- `helpers/`: Mocks, fakes, and test utilities
- `core/`: Tests for core functionality and services

## 🚀 Running Tests

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/unit/habit_test.dart
```

Run tests with coverage:
```bash
flutter test --coverage
```

Run tests in watch mode (auto-rerun on changes):
```bash
flutter test --watch
```

## 📊 Test Coverage

Current test coverage includes:
- **Models**: Habit, Badge, UserStats, JournalEntry
- **Widgets**: BadgeShowcaseWidget, LevelProgressBar, Auth screens
- **Utilities**: DateTimeHelpers for date/time operations

### Coverage Goals
- Maintain >80% code coverage for critical business logic
- All domain models should have comprehensive unit tests
- All custom widgets should have widget tests
- Integration tests for key user flows

## 🎯 Writing Tests

### Unit Tests
Unit tests should:
- Test a single unit of functionality in isolation
- Use descriptive test names that explain what is being tested
- Follow the Arrange-Act-Assert pattern
- Cover edge cases and error conditions

Example:
```dart
test('should calculate current streak correctly when completed today', () {
  // Arrange
  final habit = Habit(
    title: 'Test',
    completedDates: [today, yesterday, twoDaysAgo],
  );

  // Act
  final streak = habit.currentStreak;

  // Assert
  expect(streak, 3);
});
```

### Widget Tests
Widget tests should:
- Test widget rendering and user interactions
- Use `ProviderScope` for Riverpod widgets
- Test both visual appearance and behavior
- Verify accessibility features

Example:
```dart
testWidgets('should display level and XP information', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: LevelProgressBar()),
    ),
  );

  expect(find.text('Level 1'), findsOneWidget);
});
```

## 🔧 Test Utilities

### DateTimeHelpers
Utility functions for date/time operations in tests:
- `formatDate()`: Format dates for display
- `isSameDay()`: Compare dates ignoring time
- `daysBetween()`: Calculate days between dates
- `getPastDays()`: Generate list of past dates

### Mock Controllers
Mock implementations of controllers for testing:
- `MockGamificationController`: For testing gamification features
- Use Riverpod's `overrideWith` for dependency injection

## 📝 Best Practices

1. **Keep tests isolated**: Each test should be independent
2. **Use descriptive names**: Test names should clearly describe what is being tested
3. **Test behavior, not implementation**: Focus on what the code does, not how
4. **Cover edge cases**: Test boundary conditions and error scenarios
5. **Keep tests fast**: Unit tests should run quickly
6. **Maintain tests**: Update tests when code changes

## 🐛 Debugging Tests

Run tests with verbose output:
```bash
flutter test --reporter expanded
```

Run a single test:
```bash
flutter test test/unit/habit_test.dart --name "should calculate current streak"
```

## 📚 Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/cookbooks/testing)
