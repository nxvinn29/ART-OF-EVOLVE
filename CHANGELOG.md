# Changelog

## [Unreleased]

## [1.0.1+2] - 2025-12-25

### Added
- Added `test/README.md` and `assets/images/README.md` documentation.
- Added `STRUCTURE.md` for architecture overview.
- Added `AppConstants` for shared strings and storage keys.
- Added `AppException` and `Logger` utilities.
- Added properties documentation to `Badge` and `UserStats` models.
- Added unit tests for `Badge` and `UserStats`.
- Added `ValidationUtils` and enhanced `DateUtils`.

### Changed
- Refactored `FormatToolbar` to use `AppConstants` and extracted `ToolbarItem`.
- Updated `pubspec.yaml` dependencies and version.
- Enhanced `README.md` with better badges and description.
- Updated `CONTRIBUTING.md` with testing coverage instructions.
- Stricter lint rules in `analysis_options.yaml`.

## [Unreleased] - 2025-12-21

### Refactor
- Refactored `AccountScreen` into modular widgets.
- Refactored `TodosScreen` for better code organization and UI polishes.
- Centralized UI constants in `AppTheme`.

### Testing
- Added unit tests for `GoalRepository`.
- Added `mockito` for improved test coverage.

### Maintenance
- Updated `analysis_options.yaml`.
- Enhanced `README.md`.
- Added documentation to core services.


All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-20

### Added
- Core habit tracking with daily check-ins.
- Gamification system with XP, Levels, and Badges.
- Journaling 2.0 with rich entries, voice notes, and mood tracking.
- Focus Timer (Pomodoro) for deep work.
- Self-Care suite with meditation, gratitude log, and to-do lists.
- Custom "Soft Pastel" and "Vibrant" themes.

### Changed
- Improved code quality by enforcing single quotes across the codebase.
- Enhanced documentation and project structure.
