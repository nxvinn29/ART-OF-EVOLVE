# Art of Evolve - Application Architecture

## Overview
Art of Evolve is a holistic self-improvement application built with Flutter, focusing on goals, habits, self-care, and personal growth tracking. The application follows clean architecture principles with a feature-based modular structure.

## Architecture Pattern

### Clean Architecture Layers
The application is organized into three main layers:

1. **Presentation Layer** (`presentation/`)
   - UI components (screens, widgets)
   - State management (Riverpod controllers)
   - User input handling

2. **Domain Layer** (`domain/`)
   - Business logic
   - Entities/Models
   - Use cases

3. **Data Layer** (`data/`)
   - Repositories
   - Data sources (local/remote)
   - Data models

## Project Structure

```
lib/
├── src/
│   ├── core/                    # Shared core functionality
│   │   ├── data/               # Repository interfaces
│   │   ├── theme/              # App theming
│   │   └── utils/              # Utilities and helpers
│   │
│   ├── features/               # Feature modules
│   │   ├── auth/              # Authentication
│   │   ├── goals/             # Goal management
│   │   ├── habits/            # Habit tracking
│   │   ├── todos/             # Todo management
│   │   ├── self_care/         # Self-care & journaling
│   │   ├── gamification/      # XP, levels, badges
│   │   ├── statistics/        # Progress visualization
│   │   ├── settings/          # App settings
│   │   ├── onboarding/        # User onboarding
│   │   ├── home/              # Home dashboard
│   │   └── account/           # User account
│   │
│   ├── services/              # Application services
│   │   ├── storage/           # Hive storage service
│   │   ├── notifications/     # Local notifications
│   │   └── firebase/          # Firebase integration
│   │
│   └── routing/               # Navigation & routing
│
└── main.dart                  # Application entry point
```

## Feature Module Structure

Each feature follows a consistent structure:

```
feature/
├── data/
│   └── *_repository.dart      # Data access implementation
├── domain/
│   └── *.dart                 # Domain models
└── presentation/
    ├── *_controller.dart      # State management
    ├── *_screen.dart          # Main screen
    └── widgets/               # Feature-specific widgets
```

## State Management

### Riverpod
The application uses **Riverpod** for state management, providing:
- Type-safe dependency injection
- Reactive state updates
- Easy testing and mocking
- Compile-time safety

### Provider Types
- **Provider**: For read-only dependencies
- **StateProvider**: For simple state
- **StateNotifierProvider**: For complex state logic
- **StreamProvider**: For reactive data streams

### Example
```dart
final goalsProvider = StateNotifierProvider<GoalsController, AsyncValue<List<Goal>>>((ref) {
  return GoalsController(ref.watch(goalRepositoryProvider));
});
```

## Data Persistence

### Hive
Local data storage uses **Hive**, a lightweight NoSQL database:
- Fast read/write operations
- Type-safe with code generation
- Offline-first architecture
- Encrypted storage support

### Storage Boxes
- `goals`: User goals
- `habits`: Habit tracking data
- `todos`: Todo items
- `journal`: Journal entries
- `user`: User profile and settings

### Firebase Integration
- **Authentication**: User sign-in/sign-up
- **Firestore**: Cloud data sync (optional)
- **Cloud Messaging**: Push notifications

## Navigation

### GoRouter
The app uses **GoRouter** for declarative routing:
- Type-safe navigation
- Deep linking support
- Nested navigation
- Route guards for authentication

### Route Structure
```dart
/                          # Home screen
/onboarding               # Onboarding flow
/auth                     # Authentication
/goals                    # Goals list
/goals/:id                # Goal details
/habits                   # Habits list
/todos                    # Todos list
/self-care                # Self-care hub
/statistics               # Statistics dashboard
/settings                 # App settings
```

## Key Features

### 1. Gamification System
- **XP (Experience Points)**: Earned through completing tasks
- **Levels**: Progress through levels based on XP
- **Badges**: Achievements for milestones
- **Streaks**: Track consecutive days of habit completion

### 2. Habit Tracking
- Create custom habits with icons and colors
- Daily completion tracking
- Streak calculation
- Reminder notifications
- Visual progress indicators

### 3. Goal Management
- Set goals with target dates
- Track progress toward goals
- Mark goals as achieved
- Filter and categorize goals

### 4. Self-Care
- **Journaling**: Daily reflections and mood tracking
- **Focus Timer**: Pomodoro-style timer
- **Mood Tracking**: Track emotional well-being

### 5. Statistics & Insights
- Weekly/monthly progress charts
- Habit completion rates
- XP and level progression
- Achievement showcase

## Design Patterns

### Repository Pattern
Abstracts data access behind interfaces:
```dart
abstract class IGoalsRepository {
  Future<List<Goal>> getGoals();
  Future<void> saveGoal(Goal goal);
  Future<void> deleteGoal(String id);
}
```

### Controller Pattern
Manages feature state and business logic:
```dart
class GoalsController extends StateNotifier<AsyncValue<List<Goal>>> {
  final IGoalsRepository _repository;
  
  Future<void> addGoal(Goal goal) async {
    await _repository.saveGoal(goal);
    await loadGoals();
  }
}
```

### Service Locator
Riverpod providers act as service locators:
```dart
final goalRepositoryProvider = Provider<IGoalsRepository>((ref) {
  return GoalRepository(HiveService.goalsBox);
});
```

## Testing Strategy

### Test Pyramid
1. **Unit Tests** (70%)
   - Models and business logic
   - Utilities and helpers
   - Service classes

2. **Widget Tests** (20%)
   - UI components
   - User interactions
   - Screen layouts

3. **Integration Tests** (10%)
   - End-to-end flows
   - Feature integration
   - Navigation flows

### Test Organization
```
test/
├── unit/              # Unit tests
├── widgets/           # Widget tests
└── integration_test/  # Integration tests
```

## Performance Considerations

### Optimization Strategies
1. **Lazy Loading**: Load data on demand
2. **Caching**: Cache frequently accessed data
3. **Pagination**: For large lists
4. **Debouncing**: For search and input
5. **Memoization**: Cache computed values

### Build Optimization
- Use `const` constructors where possible
- Minimize widget rebuilds
- Use `ListView.builder` for long lists
- Implement proper `shouldRebuild` logic

## Security

### Data Protection
- Local data encrypted with Hive
- Secure authentication with Firebase
- No sensitive data in logs
- Proper error handling

### Best Practices
- Input validation
- Sanitize user input
- Secure API communication
- Regular dependency updates

## Accessibility

### Features
- Screen reader support
- Semantic labels
- Sufficient color contrast
- Keyboard navigation
- Scalable text

## Internationalization

### Future Support
The architecture supports i18n through:
- Localization files
- Language-agnostic data models
- Flexible date/time formatting

## Continuous Integration

### GitHub Actions
- Automated testing on PR
- Code quality checks
- Build verification
- Coverage reporting

## Future Enhancements

### Planned Features
1. **Social Features**: Share progress with friends
2. **AI Insights**: Personalized recommendations
3. **Wearable Integration**: Sync with fitness trackers
4. **Voice Commands**: Voice-activated task management
5. **Collaborative Goals**: Team goals and challenges

### Technical Improvements
1. **Offline Sync**: Robust offline-first with sync
2. **Performance**: Further optimization
3. **Accessibility**: Enhanced a11y features
4. **Testing**: Increase coverage to 90%+

## Contributing

### Code Style
- Follow Dart style guide
- Use meaningful names
- Add documentation
- Write tests for new features

### Pull Request Process
1. Create feature branch
2. Implement changes with tests
3. Run `flutter analyze`
4. Submit PR with description
5. Address review feedback

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)
- [Firebase Flutter](https://firebase.flutter.dev)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Last Updated**: January 1, 2026  
**Version**: 1.6.0  
**Maintainer**: Art of Evolve Team
