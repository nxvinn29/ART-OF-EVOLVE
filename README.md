# 🌿 Art of Evolve 

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Riverpod](https://img.shields.io/badge/State-Riverpod_2.0-purple?style=for-the-badge)](https://riverpod.dev/)
[![Hive](https://img.shields.io/badge/Storage-Hive-orange?style=for-the-badge)](https://docs.hivedb.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)](https://github.com/nxvinn29/ART-OF-EVOLVE/graphs/commit-activity)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg?style=for-the-badge)](CONTRIBUTING.md)

**Art of Evolve** is a premium, holistic self-improvement application built with Flutter. It seamlessly combines specific habit tracking, task management, journaling, and focus tools into a single, beautiful "Soft Pastel" aesthetic interface. Gamify your life, track your growth with detailed stats, and evolve into your best self.  

---

## ✨ Key Features

### 🎯 **Habit Tracking & Gamification**
*   **Track Habits**: Build consistency with daily check-ins.
*   **XP & Leveling**: Earn XP for every habit completed. Level up as you grow!
*   **Badges**: Unlock unique achievements like "First Step" and "Streak Master".
*   **Streaks**: Visualize your consistency with flame streaks. 🔥

### 📝 **Journal 2.0**
*   **Rich Entries**: Capture your day with text, mood icons, and tags.
*   **Voice Notes**: Record your thoughts when you're on the go. 🎙️
*   **Creative Canvas**: Express yourself with drawings and sketches. 🎨
*   **Get Inspired**: Stuck? Use the built-in "Prompt Generator" for ideas.
*   **Mood Tracking**: beautifully animated mood selector.

### 📱 **Home Widgets**
*   **Quick Glance**: View your daily habit progress right from your home screen.
*   **Stay Motivated**: Keeping your goals visible ensures you never miss a beat.

### ⏱️ **Focus Timer (Pomodoro)**
*   **Stay Flow**: Built-in circular timer for deep work sessions.
*   **Presets**: Quick start for 25m Focus, 5m Break, or 15m Long Break.
*   **Notifications**: Get alerted when your session is done. 🔔

### 🧘 **Self-Care Suite**
*   **Meditation**: Simple player for mindfulness sessions.
*   **Gratitude Log**: A dedicated space to count your blessings.
*   **To-Do Lists**: Manage daily tasks with a "Trash & Restore" safety net.

---

## 🎨 Tech Stack

*   **Framework**: Flutter (Dart)
*   **State Management**: Riverpod 2.0 (Code Generation)
*   **Local Database**: Hive (NoSQL, fast & offline-first)
*   **Backend**: Firebase (Auth & Firestore Sync)
*   **Navigation**: GoRouter
*   **Audio & Media**: `audioplayers`, `record`
*   **Creative**: `flutter_drawing_board`
*   **Widgets**: `home_widget`
*   **Polishing**: `confetti`
*   **Theme**: Custom "Soft Pastel" & "Vibrant" Design Systems

---

## 🚀 Getting Started

1.  **Clone the repository**
    ```bash
    git clone https://github.com/nxvinn29/ART-OF-EVOLVE.git
    cd ART-OF-EVOLVE
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the app**
    ```bash
    flutter run
    ```

## 🛠️ Development

### Analysis & Testing

#### Static Analysis
Run static analysis to ensure code quality:
```bash
flutter analyze
```

#### Unit Tests
Run unit tests for business logic and controllers:
```bash
flutter test test/unit/
```

Our unit tests cover:
- **Controllers**: GoalsController, JournalController, SettingsController, AuthController, GamificationController, OnboardingController, HabitsController
- **Repositories**: GoalRepository
- **Models**: Goal, JournalEntry, Habit, Achievement, UserSettings, Badge, UserStats
- **Utilities**: StreakCalculator, DateTimeHelpers, Validators, ValidationUtils, StringExtensions
- **Services**: GamificationService, NotificationService

#### Widget Tests
Run widget tests for UI components:
```bash
flutter test test/widgets/
```

Widget tests cover:
- **Screens**: GoalsScreen, JournalScreen, SettingsScreen, HomeScreen, AccountScreen, StatisticsScreen
- **Components**: LevelProgressBar, BadgeShowcaseWidget, HabitCard, MoodSelector, AnimatedCheckbox
- **Forms**: Goal creation, Journal entry, Habit tracking

#### Integration Tests
Run integration tests for complete user flows:
```bash
flutter test integration_test/
```

Integration tests cover:
- Habit creation and tracking flow
- Journal entry creation and management
- Mood tracking workflow
- Achievement unlocking
- Theme switching

#### Run All Tests
Execute all tests at once:
```bash
flutter test
```

#### Test Coverage
Generate and view test coverage report:
```bash
# Generate coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Current Test Coverage**: 
- Unit Tests: 85%+
- Widget Tests: 70%+
- Integration Tests: Major user flows covered

### Formatting
Keep the code clean:
```bash
flutter format .
```

### Code Quality Standards
- All new features must include unit tests
- UI components should have widget tests
- Critical user flows require integration tests
- Maintain minimum 80% code coverage
- Follow Dart style guide and lint rules

---

## 📸 Screenshots

| Dashboard | Journal | Focus Timer |
|:---:|:---:|:---:|
| ![Dashboard](https://via.placeholder.com/200x400/E3F2FD/2D3142?text=Dashboard) | ![Journal](https://via.placeholder.com/200x400/F3E5F5/2D3142?text=Journal) | ![Focus Timer](https://via.placeholder.com/200x400/E0F7FA/2D3142?text=Focus+Timer) |

---

## 📂 Project Structure

```text
lib/
├── main.dart             # Entry point
├── src/
│   ├── app.dart          # Root widget & Routing
│   ├── core/             # Shared utilities & theme
│   ├── features/         # Feature-based organization
│   │   ├── auth/         # Login & Sign up
│   │   ├── goals/        # Goal tracking
│   │   ├── habits/       # Habit tracking & consistency
│   │   ├── home/         # Dashboard & Widgets
│   │   └── self_care/    # Journal, Meditation, etc.
│   └── services/         # Firebase, Notifications, Hive
└── test/                 # Unit & Widget tests
```

--

## 🤝 Contributing

Contributions are welcome! Please check out our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

Made with ❤️ by **nxvinn29** © 2025
