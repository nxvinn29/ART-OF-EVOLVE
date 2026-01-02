# Testing Strategy

## Overview

This document outlines the comprehensive testing strategy for the Art of Evolve application. Our testing approach ensures code quality, reliability, and maintainability through multiple layers of testing.

## Testing Pyramid

We follow the testing pyramid principle:

```
        /\
       /  \    E2E Tests (10%)
      /____\
     /      \  Integration Tests (20%)
    /________\
   /          \ Unit Tests (70%)
  /__________\
```

### Unit Tests (70%)
- **Purpose**: Test individual functions, methods, and classes in isolation
- **Location**: `test/unit/`
- **Coverage Target**: 85%+
- **Examples**: Model tests, utility function tests, controller logic tests

### Widget Tests (20%)
- **Purpose**: Test UI components and their interactions
- **Location**: `test/widgets/`
- **Coverage Target**: 75%+
- **Examples**: Screen tests, custom widget tests, layout tests

### Integration Tests (10%)
- **Purpose**: Test complete user flows and feature interactions
- **Location**: `integration_test/`
- **Coverage Target**: Critical user paths
- **Examples**: Habit creation flow, authentication flow, data sync

## Test Organization

### Directory Structure

```
test/
├── unit/                    # Unit tests
│   ├── models/             # Domain model tests
│   ├── controllers/        # Controller logic tests
│   └── utils/              # Utility function tests
├── widgets/                # Widget tests
│   ├── screens/           # Full screen tests
│   └── components/        # Component widget tests
├── helpers/               # Test helpers and utilities
└── TESTING_GUIDE.md       # Detailed testing guide

integration_test/
├── flows/                 # Complete user flow tests
└── features/              # Feature-specific integration tests
```

## Testing Standards

### Unit Test Standards

1. **Naming Convention**
   ```dart
   void main() {
     group('ClassName Tests', () {
       test('should do something when condition', () {
         // Arrange
         // Act
         // Assert
       });
     });
   }
   ```

2. **AAA Pattern**
   - **Arrange**: Set up test data and preconditions
   - **Act**: Execute the code under test
   - **Assert**: Verify the expected outcome

3. **Test Coverage**
   - All public methods must be tested
   - Edge cases and error conditions must be covered
   - Happy path and unhappy path scenarios

### Widget Test Standards

1. **Naming Convention**
   ```dart
   testWidgets('renders component with correct data', (tester) async {
     // Arrange
     // Act
     await tester.pumpWidget(...);
     // Assert
     expect(find.text('Expected'), findsOneWidget);
   });
   ```

2. **Best Practices**
   - Use `ProviderScope` for Riverpod-dependent widgets
   - Mock external dependencies
   - Test user interactions (taps, scrolls, inputs)
   - Verify visual elements and layout

3. **Common Patterns**
   ```dart
   // Pump widget with providers
   await tester.pumpWidget(
     ProviderScope(
       overrides: [
         providerName.overrideWith(...),
       ],
       child: MaterialApp(home: WidgetUnderTest()),
     ),
   );
   ```

### Integration Test Standards

1. **Naming Convention**
   ```dart
   testWidgets('complete habit creation and tracking flow', (tester) async {
     // Test complete user journey
   });
   ```

2. **Best Practices**
   - Test realistic user scenarios
   - Minimize mocking
   - Test data persistence
   - Verify navigation flows

## Test Data Management

### Test Fixtures

Create reusable test data in `test/helpers/`:

```dart
class TestFixtures {
  static Habit createTestHabit({
    String? title,
    int? color,
  }) {
    return Habit(
      title: title ?? 'Test Habit',
      color: color ?? Colors.blue.value,
      iconCodePoint: Icons.star.codePoint,
    );
  }
}
```

### Mock Data

Use consistent mock data across tests:
- User profiles
- Habits
- Journal entries
- Goals

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/habit_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Run Integration Tests
```bash
flutter test integration_test/
```

## Continuous Integration

### Pre-commit Checks
- Run `flutter analyze`
- Run all unit tests
- Verify no lint errors

### CI Pipeline
1. **Lint Check**: `flutter analyze`
2. **Unit Tests**: `flutter test --coverage`
3. **Widget Tests**: Included in `flutter test`
4. **Coverage Report**: Generate and upload coverage
5. **Integration Tests**: Run on emulator/simulator

## Coverage Goals

| Test Type | Current | Target |
|-----------|---------|--------|
| Unit Tests | 85% | 90% |
| Widget Tests | 75% | 80% |
| Integration Tests | Critical Paths | All Major Flows |
| Overall | 80% | 85% |

## Testing Tools

### Dependencies
- `flutter_test`: Core testing framework
- `flutter_riverpod`: State management testing
- `mockito`: Mocking framework (when needed)
- `integration_test`: E2E testing

### Helpful Commands
```bash
# Run tests in watch mode
flutter test --watch

# Run tests with verbose output
flutter test --verbose

# Run specific test group
flutter test --name "Habit Model Tests"
```

## Best Practices

### DO
✅ Write tests before fixing bugs (TDD for bug fixes)
✅ Test edge cases and error conditions
✅ Use descriptive test names
✅ Keep tests independent and isolated
✅ Mock external dependencies
✅ Test user-facing behavior, not implementation details

### DON'T
❌ Test private methods directly
❌ Create interdependent tests
❌ Ignore failing tests
❌ Write tests that depend on external services
❌ Duplicate test logic
❌ Skip testing error handling

## Test Maintenance

### Regular Reviews
- Review test coverage monthly
- Update tests when requirements change
- Refactor tests alongside production code
- Remove obsolete tests

### Test Debt
- Track untested code
- Prioritize testing critical paths
- Add tests for bug fixes
- Improve flaky tests

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/cookbooks/testing)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)

## Contributing

When adding new features:
1. Write unit tests for business logic
2. Write widget tests for UI components
3. Add integration tests for critical flows
4. Update this strategy document if needed
5. Ensure all tests pass before submitting PR

## Conclusion

A robust testing strategy ensures the Art of Evolve app remains reliable, maintainable, and bug-free. By following these guidelines, we maintain high code quality and user satisfaction.
