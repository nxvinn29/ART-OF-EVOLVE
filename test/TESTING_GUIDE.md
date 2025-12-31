# Testing Guide for Art of Evolve

## Overview
This guide provides detailed information about testing practices and conventions for the Art of Evolve project.

## Test Structure

### Directory Organization
```
test/
├── unit/              # Unit tests for business logic
├── widgets/           # Widget tests for UI components
├── helpers/           # Test helpers and utilities
└── README.md          # This file

integration_test/      # Integration tests for user flows
```

## Running Tests

### Unit Tests
```bash
# Run all unit tests
flutter test test/unit/

# Run specific test file
flutter test test/unit/goals_controller_test.dart

# Run with coverage
flutter test test/unit/ --coverage
```

### Widget Tests
```bash
# Run all widget tests
flutter test test/widgets/

# Run specific widget test
flutter test test/widgets/goals_screen_test.dart
```

### Integration Tests
```bash
# Run all integration tests
flutter test integration_test/

# Run specific integration test
flutter test integration_test/habit_creation_flow_test.dart
```

## Writing Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    setUp(() {
      // Setup code
    });

    tearDown(() {
      // Cleanup code
    });

    test('should do something', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = functionUnderTest(input);
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('WidgetName Tests', () {
    testWidgets('should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: WidgetUnderTest(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

## Test Coverage Goals

- **Unit Tests**: Minimum 80% coverage
- **Widget Tests**: Minimum 70% coverage
- **Integration Tests**: All critical user flows

## Best Practices

1. **Arrange-Act-Assert Pattern**: Structure tests clearly
2. **Descriptive Names**: Use clear, descriptive test names
3. **One Assertion Per Test**: Focus each test on one behavior
4. **Mock External Dependencies**: Use mocks for repositories and services
5. **Test Edge Cases**: Include tests for error conditions
6. **Keep Tests Fast**: Unit tests should run in milliseconds
7. **Avoid Test Interdependence**: Each test should be independent

## Mocking

### Example Mock Repository
```dart
class MockGoalsRepository implements IGoalsRepository {
  final List<Goal> _goals = [];
  bool shouldThrowError = false;

  @override
  Future<List<Goal>> getGoals() async {
    if (shouldThrowError) throw Exception('Error');
    return List.from(_goals);
  }
}
```

## Continuous Integration

Tests are automatically run on:
- Every pull request
- Every commit to main branch
- Before deployment

## Troubleshooting

### Common Issues

**Issue**: Tests fail with "Box not found"
**Solution**: Ensure Hive is properly initialized in test setup

**Issue**: Widget tests timeout
**Solution**: Use `pumpAndSettle()` after interactions

**Issue**: Async tests fail intermittently
**Solution**: Use `await` properly and add `pumpAndSettle()`

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/cookbooks/testing)
