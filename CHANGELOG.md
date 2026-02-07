# Changelog

## [1.6.0+22] - 2026-02-07
### Added
- **Utilities**: Added `isTomorrow` to `AppDateUtils` with tests.

## [1.6.0+21] - 2026-02-03
### Added
- **Utilities**: Added `isSameMonth` and `isSameYear` to `AppDateUtils` with tests.
- **Utilities**: Added `containsAny` to `StringExtensions` with tests.
- **Exceptions**: Added `TimeoutException` to `AppException` with tests.
- **Features**: Added `updateHabit` to `HabitsController`.

### Enhanced
- **Project Tracking**: Finalized daily contributions and updated `CHANGELOG.md`.

## [1.6.0+20] - 2026-02-03
### Added
- **Utilities**: Added `isValidIPAddress` (IPv4) to `ValidationUtils` with comprehensive unit tests.
- **Utilities**: Added `removeWhitespace` to `StringExtensions` with comprehensive unit tests.
- **Exceptions**: Added `UnauthorizedException` to `AppException` for better authentication error handling, including unit tests.

### Enhanced
- **Documentation**: Added detailed KDoc documentation for `QuoteService` with usage examples.
- **Project Tracking**: Updated `CHANGELOG.md` and `task.md` to reflect second set of daily contributions.

## [1.6.0+19] - 2026-02-02
### Added
- **Utilities**: Added `isLeap` (DateTime variant) to `AppDateUtils` with comprehensive unit tests.
- **Utilities**: Added `isBlank` to `StringExtensions` with comprehensive unit tests for empty/whitespace strings.

### Enhanced
- **Documentation**: Added detailed KDoc documentation for `GoalRepository`, `HiveService`, and `goalRepositoryProvider`.
- **Documentation**: Improved provider documentation and usage examples for persistence layer.
- **Project Tracking**: Updated `CHANGELOG.md` and `task.md` to reflect daily progress.

## [1.6.0+18] - 2026-01-25
### Added
- **Models**: Added `isCompletedYesterday` and `isCompletedOnDate` to `Habit` model with comprehensive unit tests.
- **Utilities**: Added `isYesterday` and `getDatesInWeek` to `AppDateUtils` with comprehensive unit tests.
- **Unit Tests**: Created `habit_model_test.dart` to verify habit logic and streak calculations.

### Enhanced
- **UI Components**: Refactored `MoodTrackerWidget` to include an `onMoodSelected` callback for better parent integration.
- **Documentation**: Improved KDoc documentation for `Habit` model, `AppDateUtils`, and `MoodTrackerWidget`.
- **Project Tracking**: Updated `CHANGELOG.md` and `task.md` to reflect latest contributions.

## [1.6.0+17] - 2026-01-24
### Added
- **Utilities**: Added `toPascalCase` to `StringExtensions` with comprehensive unit tests.
- **Utilities**: Added `getRelativeTime` to `AppDateUtils` with comprehensive unit tests for relative timestamps (e.g., "Just now", "5m ago").

### Fixed
- **Code Quality**: Resolved lint errors in `animated_checkbox_test.dart` including `prefer_const_constructors` and `prefer_const_declarations`.

### Enhanced
- **Documentation**: Verified and updated KDoc documentation for `TodoRepository`.
- **Project Tracking**: Updated `CHANGELOG.md` to reflect daily progress.

## [1.6.0+16] - 2026-01-23
### Added
- **Repositories**: Added `clearUserProfile` to `UserRepository` with comprehensive unit tests.
- **Utilities**: Added `isValidBio` and `isValidAge` to `ValidationUtils` with comprehensive unit tests.

### Enhanced
- **Documentation**: Added detailed KDoc documentation for `OnboardingController`.
- **UI Components**: Enhanced `WaterTrackerWidget` with a reactive "Goal Reached! 💧" success indicator and updated widget tests.
- **Project Structure**: Updated `task.md` and `CHANGELOG.md` to reflect daily progress.
 
 ## [1.6.0+15] - 2026-01-22
 ### Added
 - **Utilities**: Added `getDaysInMonth` and `isLastDayOfMonth` to `AppDateUtils` with tests.
 - **Utilities**: Added `toCamelCase` and `isAlphanumeric` to `StringExtensions` with tests.
 - **Unit Tests**: Added edge case tests for `UserStats` model.
 
 ### Enhanced
 - **Documentation**: Added comprehensive KDoc for `Badge` and `UserStats` domain models.
 

All notable changes to this project will be documented in this file.


## [1.6.0+14] - 2026-01-21
### Added
- **Utilities**: Added `daysBetween`, `addDays`, `isToday` to `AppDateUtils` with tests.
- **Utilities**: Added `isValidHexColor` to `ValidationUtils` with tests.
- **Unit Tests**: Created `UserSettings` tests and enhanced utils tests.

### Enhanced
- **Documentation**: Added KDoc for `UserSettings`.

## [1.6.0+13] - 2026-01-20
### Fixed
- **Code Quality**: Resolved remaining lint errors (`omit_local_variable_types`, `prefer_final_locals`) across `test` and `lib` directories.
- **Refactoring**: strict typing in `StringExtensions`, `DashboardHeader`, and various widget tests.

## [1.6.0+12] - 2026-01-19
### Added
- **Utilities**: Added `truncate`, `toKebabCase`, `toSnakeCase` to `StringExtensions` with tests.
- **Utilities**: Added `isFuture`, `isPast`, `isLeapYear` to `AppDateUtils` with tests.
- **Utilities**: Added `isValidName`, `isValidZipCode` to `ValidationUtils` with tests.
- **Widget Tests**: Added tests for `ToolbarItem` and `FormatToolbar`.

### Enhanced
- **Documentation**: Added KDoc for `ToolbarItem`, `OnboardingController`, `NotificationService`.

## [1.6.0+11] - 2026-01-16
### Added
- **Unit Tests**: Added `HiveService` tests and enhanced `StringExtensions` tests.
- **Widget Tests**: Added tests for `AddTodoDialog`, `DashboardView`, `OnboardingScreen`, `VoiceRecorderWidget`, and `JournalEditorScreen`.
- **Utilities**: Added `wordCount`, `isNumeric`, and `reverse` to `StringExtensions`.

### Enhanced
- **Documentation**: Added KDoc for `HiveService` and `AddTodoDialog`.

## [1.6.0+10] - 2026-01-15
### Added
- **Utilities**: Extended `StringExtensions` with `toTitleCase` and `initials` methods.
- **Unit Tests**: Added tests for `PerformanceObserver`, `UserProfile`, and `StringExtensions`.
- **Refactoring**: Enhanced `DashboardHeader` to handle empty user names gracefully.

### Enhanced
- **Monitoring**: Refactored `PerformanceObserver` to use `Logger` and support dependency injection.
- **Models**: Improved `UserProfile` domain model with value equality, `hashCode`, and `toString` overrides.

## [1.6.0+9] - 2026-01-14
### Added
- **New Features**: Added reactive `watchTodos`, `watchEntries`, and `watchUserProfile` methods to repositories for real-time UI updates.
- **Utilities**: Added `isValidPhoneNumber`, `isValidUrl` to `ValidationUtils`, and `getStartOfWeek`, `isSameWeek` to `DateUtils` with comprehensive tests.
- **Widget Tests**: Added `DashboardHeader` widget tests with provider mocking.
- **Unit Tests**: Enhanced test coverage for `TodoRepository`, `JournalRepository`, `UserRepository`, `QuoteService`, and utilities.

### Enhanced
- **Documentation**: Added detailed KDoc to:
  - `DashboardHeader`
  - `QuoteService`
  - `TodoRepository`
  - `JournalRepository`
  - `UserRepository`
  - `ValidationUtils`
  - `AppDateUtils`

## [1.6.0+8] - 2026-01-10
### Added
- **Documentation**: Added KDoc for `MoodTrackerWidget`, `GamificationOverlay`, and `DrawingCanvasWidget`.
- **Widget Tests**: Enhanced `GamificationOverlay` tests to verify badge unlocks and XP gain feedback.

## [1.6.0+7] - 2026-01-09
### Added
- **Unit Tests**: Added `GoalRepository` tests and enhanced `Goal` model tests.
- **Widget Tests**: Added `GoalsScreen` and `StatisticsScreen` tests.

### Enhanced
- **Documentation**: Added KDoc for `GoalsController`, `GoalRepository`, `Goal`, `StatisticsScreen`.
- **Bug Fixes**: Fixed race condition in `GoalsController.loadGoals`.

## [1.6.0+6] - 2026-01-08
### Added
- **Widget Tests**: Added `AuthSection`, `SelfCareScreen`, `FocusTimerScreen`, and `GamificationOverlay` tests.
- **Utilities**: Added `StringExtensions` and corresponding unit tests.

### Enhanced
- **Documentation**: Comprehensive KDoc added to:
  - `AccountScreen`, `AuthScreen`, `GamificationController`, `GoalsScreen`, `HabitsList`
  - `HomeScreen`, `OnboardingScreen`, `JournalEditorScreen`, `SettingsController`
  - `StatisticsScreen`, `TodosScreen`, `DashboardView`
### Added
- **Widget Tests**: Added `AnimatedCheckbox` tests.
- **Unit Tests**: Enhanced coverage for `ValidationUtils`, `Habit`, `Badge`, and `UserStats`.

### Enhanced
- **Documentation**: Comprehensive KDoc added to:
  - `ValidationUtils`
  - `HabitsController`
  - `PushNotificationService`
  - `Habit`, `Badge`, `UserStats` models
  - `AnimatedCheckbox`
  - `AuthController`

## [1.6.0+4] - 2026-01-06
### Added
- **Unit Tests**: Added `GamificationController` and `OnboardingController` tests.
- **Widget Tests**: Added `SelfCareWidget`, `WaterTrackerWidget`, `MiniTodoListWidget`, `ProfileHeader` tests.
- **Utilities**: Enhanced `ValidationUtils` with password strength and sanitization.

### Enhanced
- **Documentation**: Added KDoc for `JournalController`, `TrashScreen`, `NotificationService`, `DashboardHeader`.
- **Models**: Added `toString()` overrides for `Goal` and `Habit` for better debugging.

## [1.6.0+3] - 2026-01-04
### Added
- **Unit Tests**: Added `TodosController` tests.
- **Widget Tests**: Enhanced `GoalsScreen` tests with interaction scenarios.
- **Documentation**: Added KDoc for `GoalsScreen` and `TodosController`.

## [1.6.0+2] - 2026-01-04

### Added
- **Widget Tests**: Added tests for `AccountScreen` and `StatisticsScreen`.
- **Documentation**: Added KDoc for `SelfCareWidget`, `WaterTrackerWidget`, `AccountScreen`, and `DrawingCanvasWidget`.
- **Refactoring**: Improved `DrawingCanvasWidget` testability.

## [1.6.0] - 2026-01-03
### Added
- **Performance Monitoring**: Integrated `PerformanceObserver` for Riverpod state tracking.
- **Documentation**:
  - `ROADMAP.md` describing 2026 milestones.
  - `DEPLOYMENT.md` guide for release processes.
  - `API_RESPONSE_MODELS.md` detailing backend schemas.
  - `CODE_OF_CONDUCT.md` for community guidelines.
- **Testing Infrastructure**:
  - Comprehensive unit test suite for services and controllers (`PushNotificationService`, `AuthController`, `ThemeController`, `QuoteService`, `AppException`).
  - Widget test suite for home and settings widgets (`WaterTrackerWidget`, `SelfCareWidget`, `ThemeToggleWidget`).
- **CI/CD**: Added GitHub Actions workflow (`ci.yml`) and `PULL_REQUEST_TEMPLATE.md`.

### Enhanced
- Standardized code style with `.editorconfig` and `.gitattributes`.
- Improved API documentation in `API_DOCUMENTATION.md`.

## [1.5.0] - 2025-12-31

### Added
- **Integration Tests**: Comprehensive end-to-end testing for critical user flows
  - Habit creation and tracking flow tests
  - Journal entry creation and management tests
  - Mood tracking workflow tests
  - Achievement unlocking flow tests
  - Theme switching flow tests
- **Enhanced Unit Tests**: Extended test coverage for controllers
  - `GoalsController` tests (13 test cases) covering CRUD operations and state management
  - `JournalController` tests (12 test cases) for entry management and sorting
  - `SettingsController` tests (8 test cases) for preferences and persistence
- **Widget Tests**: UI component testing
  - `GoalsScreen` tests (6 test cases) for various UI states
  - `JournalScreen` tests (5 test cases) for entry display
  - `SettingsScreen` tests (3 test cases) for settings UI
- **Documentation Enhancements**:
  - Comprehensive KDoc for `GoalsRepository` with usage examples and error handling
  - `TESTING_GUIDE.md` with templates, best practices, and troubleshooting
  - `CODE_QUALITY.md` with standards, style guide, and review checklist
  - `API_DOCUMENTATION.md` with complete API reference for all repositories and controllers
  - Enhanced README with detailed testing guide and coverage information

### Enhanced
- Improved test coverage to 85%+ for unit tests
- Better documentation across all major components
- Comprehensive testing infrastructure
- Developer experience with detailed guides and standards

### Documentation
- Added testing templates and examples
- Documented all public APIs with KDoc
- Created comprehensive developer guides
- Updated README with testing and coverage info


## [1.0.4] - 2025-12-30

### Added
- **Comprehensive Unit Tests**: Added extensive test coverage for core models
  - `Habit` model tests (13 test cases) covering creation, streak calculations, and completion tracking
  - `Badge` model tests (16 test cases) validating badge properties and predefined badges
  - `UserStats` model tests (16 test cases) for XP progression, level advancement, and badge unlocking
- **Widget Tests**: Enhanced UI component testing
  - `BadgeShowcaseWidget` tests (10 test cases) for badge display and layout validation
- **Documentation Improvements**:
  - Added comprehensive KDoc documentation to `HabitsRepository` with usage examples
  - Documented CRUD operations, reactive streams, and data persistence patterns

### Enhanced
- Improved test coverage across gamification and habits features
- Better code documentation for repository layer
- Enhanced developer experience with detailed inline documentation



## [1.0.3] - 2025-12-29

### Added
- **Dark Mode Support**: Fully implemented dark theme with custom color palette
- **Theme Controller**: Riverpod-based theme management with Hive persistence
- **Theme Toggle Widget**: Beautiful animated widget to switch between light, dark, and system themes
- **Statistics & Insights Screen**: Comprehensive analytics dashboard featuring:
  - XP and level progress visualization
  - Habits completion summary with statistics
  - Achievements and badges showcase
  - Weekly progress chart with gradient bars
  - Streak analytics (longest and active streaks)
- Theme toggle integration in Account/Settings screen
- Statistics navigation from Account screen

### Enhanced
- Dark theme with complete component styling (buttons, cards, inputs, navigation)
- App-wide theme switching capability
- Improved user experience with persistent theme preferences

## [1.0.2] - 2025-12-28

### Added
- Contributions welcome badge to README.
- GitHub Issue Templates for Bugs and Feature Requests.
- Documentation for `Goal`, `JournalEntry` models.
- Unit tests for `Goal`, `JournalEntry`, and `Logger`.
- Widget tests for `AuthScreen`.
- `structure.md` to explain project architecture.
- `AppConstants` for validation messages and hero tags.
- Warning method to `Logger` utility.

### Changed
- Updated `pubspec.yaml` description and version.
- Enhanced validation constants in `AppConstants`.
- Improved KDoc for `AuthController` and `AuthScreen`.
- Standardized documentation in `main.dart` and `app.dart`.
- Refactored `HiveService` with better error handling.
- Renamed internal variables in `HomeScreen` for clarity.
- Fixed lint issues in `main.dart` and `level_progress_bar_test.dart`.
