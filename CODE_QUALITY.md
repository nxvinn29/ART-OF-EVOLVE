# Code Quality Standards

## Overview
This document outlines the code quality standards and best practices for the Art of Evolve project.

## Code Style

### Dart Style Guide
Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

### Formatting
- Use `flutter format .` before committing
- Line length: 80 characters (configurable in `analysis_options.yaml`)
- Use trailing commas for better formatting

### Naming Conventions
- **Classes**: PascalCase (e.g., `GoalsController`)
- **Variables**: camelCase (e.g., `goalsList`)
- **Constants**: lowerCamelCase (e.g., `maxRetries`)
- **Private members**: Prefix with underscore (e.g., `_repository`)
- **Files**: snake_case (e.g., `goals_controller.dart`)

## Documentation

### KDoc-Style Comments
All public APIs must have documentation:

```dart
/// Retrieves all goals from the storage.
///
/// Returns a [Future] that completes with a [List] of all stored goals.
/// The list is a snapshot of the current state.
///
/// ## Example:
/// ```dart
/// final goals = await repository.getGoals();
/// ```
///
/// ## Throws:
/// May throw [HiveError] if the box is not open.
Future<List<Goal>> getGoals() async {
  return _box.values.toList();
}
```

### Required Documentation
- All public classes
- All public methods
- Complex algorithms
- Non-obvious code sections

## Testing Requirements

### Coverage Targets
- **Unit Tests**: 80% minimum
- **Widget Tests**: 70% minimum
- **Integration Tests**: All critical flows

### Test Requirements
- All new features must include tests
- Bug fixes should include regression tests
- Tests must be independent and repeatable
- Use descriptive test names

## Code Review Checklist

### Before Submitting PR
- [ ] Code follows style guide
- [ ] All tests pass
- [ ] New code has tests
- [ ] Documentation is updated
- [ ] No lint warnings
- [ ] Code is formatted
- [ ] Commit messages are clear

### Reviewer Checklist
- [ ] Code is readable and maintainable
- [ ] Tests are comprehensive
- [ ] Documentation is clear
- [ ] No security vulnerabilities
- [ ] Performance is acceptable
- [ ] Error handling is proper

## Static Analysis

### Running Analysis
```bash
flutter analyze
```

### Analysis Options
See `analysis_options.yaml` for configured rules.

### Common Lint Rules
- `prefer_const_constructors`
- `avoid_print`
- `prefer_final_fields`
- `unnecessary_null_checks`
- `prefer_single_quotes`

## Error Handling

### Best Practices
```dart
try {
  final result = await riskyOperation();
  return result;
} catch (e, stackTrace) {
  // Log error with context
  logger.error('Failed to perform operation', error: e, stackTrace: stackTrace);
  
  // Handle gracefully
  state = AsyncError(e, stackTrace);
}
```

### Guidelines
- Always catch specific exceptions when possible
- Log errors with context
- Provide user-friendly error messages
- Never swallow exceptions silently

## Performance

### Best Practices
- Use `const` constructors where possible
- Avoid unnecessary rebuilds
- Use `ListView.builder` for long lists
- Implement pagination for large datasets
- Profile before optimizing

## Security

### Guidelines
- Never commit secrets or API keys
- Use environment variables for sensitive data
- Validate all user input
- Sanitize data before storage
- Follow OWASP guidelines

## Git Workflow

### Commit Messages
Follow conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Test additions/changes
- `refactor:` Code refactoring
- `style:` Formatting changes
- `chore:` Maintenance tasks

### Example
```
feat: add goal completion tracking

- Implement completion percentage calculation
- Add visual progress indicator
- Update tests for new functionality
```

## Continuous Improvement

### Regular Tasks
- Review and update dependencies monthly
- Refactor code with high complexity
- Improve test coverage
- Update documentation
- Address technical debt

## Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://docs.flutter.dev/development/data-and-backend/state-mgmt/best-practices)
- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/reading)
