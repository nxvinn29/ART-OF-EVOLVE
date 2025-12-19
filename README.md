# 🌿 Art of Evolve  

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-purple?style=for-the-badge)](https://riverpod.dev/)
[![Hive](https://img.shields.io/badge/Storage-Hive-orange?style=for-the-badge)](https://docs.hivedb.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Art of Evolve** is a holistic self-improvement application built with Flutter. It combines habit tracking, task management, journaling, and focus tools into a single, beautiful "Soft Pastel" aesthetic interface. Gamify your life, track your growth, and evolve into your best self.  

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

---

## 📸 Screenshots

| Dashboard | Journal | Focus Timer |
|:---:|:---:|:---:|
| *Add screenshot link here* | *Add screenshot link here* | *Add screenshot link here* |

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
