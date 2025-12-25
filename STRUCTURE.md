# 🏗️ Project Structure & Architecture

This document describes the high-level architecture and folder structure of the **Art of Evolve** application. We follow a **Feature-First** (also known as Feature-Layer) architecture, which improves maintainability and scalability.

## 📁 Directory Structure

```text
lib/
├── src/
│   ├── app.dart                # Application Root Widget (MaterialApp configuration)
│   ├── core/                   # Core functionality shared across features
│   │   ├── constants/          # App-wide constants (colors, strings, assets)
│   │   ├── exceptions/         # Custom exception classes
│   │   ├── localization/       # l10n and internationalization setup
│   │   ├── theme/              # App theme definitions (light/dark mode)
│   │   ├── utils/              # Helper functions (dates, string formatting)
│   │   └── widgets/            # Reusable generic widgets (buttons, inputs)
│   ├── features/               # Feature modules
│   │   ├── auth/               # Authentication (Login, Register, Forgot Password)
│   │   ├── gamification/       # XP system, Badges, Leveling logic
│   │   ├── goals/              # Goal setting and tracking
│   │   ├── habits/             # Habit tracking logic and UI
│   │   ├── home/               # Home dashboard and navigation shell
│   │   └── self_care/          # Journaling, Meditation, Breathing exercises
│   └── services/               # External services and data providers
│       ├── local/              # Local storage (Hive, SharedPreferences)
│       ├── remote/             # Remote API/Firebase calls
│       └── notifications/      # Push and local notifications
└── main.dart                   # Application entry point
```

## 🏗️ Architecture Layers

Inside each feature (e.g., `lib/src/features/habits/`), we strictly follow these layers:

1.  **Presentation Layer** (`presentation/`)
    *   **Widgets**: UI components specific to this feature.
    *   **Screens/Pages**: Full-screen views.
    *   **Controllers/Providers**: State management (Riverpod) for the UI.

2.  **Domain Layer** (`domain/`)
    *   **Entities/Models**: Pure Dart classes representing the data (e.g., `Habit`, `Badge`).
    *   **Repositories (Interfaces)**: Abstract definitions of how data is accessed.

3.  **Data Layer** (`data/`)
    *   **Repositories (Implementation)**: Concrete implementations of the interfaces (e.g., `FirebaseHabitRepository`).
    *   **Data Sources**: Direct database or API clients.
    *   **DTOs**: Data Transfer Objects (if needed for serialization).

## 🔄 State Management

We use **Riverpod 2.0** with code generation (`@riverpod`) for:
*   Dependency Injection (Service Locator)
*   State Management (AsyncNotifier, Provider)
*   Caching and Data Binding

## 💾 Data Storage

*   **Firebase Firestore**: Primary cloud database for user data sync.
*   **Hive**: Local caching for offline-first capability.
*   **SharedPreferences**: Simple key-value storage for settings.

## 🎨 Design System

The app uses a custom design system defined in `lib/src/core/theme/`.
*   **Colors**: defined in `AppColors`
*   **Typography**: defined in `AppTextStyles`
*   **Spacing**: Standard 4pt grid system (4, 8, 12, 16, 24, 32...).
