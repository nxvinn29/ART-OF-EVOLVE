# Changelog

All notable changes to this project will be documented in this file.

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
