# Project Structure

This document outlines the directory structure of the Art of Evolve project.

## Root Directory

- `lib/`: Contains the source code of the application.
- `test/`: Contains unit and widget tests.
- `android/`: Android-specific configuration and code.
- `ios/`: iOS-specific configuration and code.
- `web/`: Web-specific entries.
- `assets/`: Static assets like images and fonts.

## `lib/` Directory

### `src/` - Source Code

#### `app.dart`
The root widget (`ArtOfEvolveApp`) wrapping the application with providers and routing.

#### `core/`
Shared resources used across multiple features.
- `constants/`: App-wide constants (e.g., strings, keys).
- `theme/`: Theme definitions (colors, text styles).
- `utils/`: Helper functions (e.g., loggers, formatters).

#### `features/`
Feature-based modular architecture. Each feature contains:
- `data/`: repositories and data sources.
- `domain/`: entities and models.
- `presentation/`: widgets, screens, and controllers (Riverpod).

**Key Features:**
- `auth`: Authentication logic and screens.
- `goals`: Goal setting and tracking.
- `habits`: Habit formation tools.
- `self_care`: Journaling, meditation, etc.
- `home`: Dashboard and main navigation.

#### `services/`
Global services and external integrations.
- `storage/`: Hive database setup.
- `notifications/`: Local notification logic.

## `test/` Directory
Mirrors the `lib/` structure for `unit` and `widgets` tests.
