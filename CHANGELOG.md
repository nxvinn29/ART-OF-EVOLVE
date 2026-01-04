# Changelog

All notable changes to this project will be documented in this file.

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
