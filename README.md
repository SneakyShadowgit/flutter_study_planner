# 📚 Study Planner

A simple yet effective **Flutter study task manager** that helps you organize and track your daily study goals. Tasks are persisted locally using **Hive**, so your data is always saved between sessions.

---

## ✨ Features

- ✅ **Add Tasks** — Quickly add new study tasks via a dialog popup
- 🏷️ **Subject Tagging** — Assign each task to a subject (C Programming, Flutter, Mathematics, Network, General)
- ☑️ **Mark as Complete** — Check off tasks with a tap; completed tasks are shown with a strikethrough
- 🗑️ **Swipe to Delete** — Swipe a task left to remove it with a confirmation snackbar
- 📊 **Progress Card** — Visual circular progress indicator showing today's completion percentage
- 💾 **Local Persistence** — All tasks are saved locally using Hive (no internet required)
- 📱 **Cross-Platform** — Runs on Android, iOS, Windows, Linux, macOS, and Web

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.11.5`
- Dart SDK (comes with Flutter)
- Android Studio / VS Code with Flutter & Dart plugins

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SneakyShadowgit/flutter_study_planner.git
   cd flutter_study_planner
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 🛠️ Built With

| Package | Version | Purpose |
|---|---|---|
| [Flutter](https://flutter.dev) | SDK | UI Framework |
| [hive](https://pub.dev/packages/hive) | ^2.2.3 | Local NoSQL database |
| [hive_flutter](https://pub.dev/packages/hive_flutter) | ^1.1.0 | Hive integration for Flutter |

---

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry point & StudyPlannerApp widget
│
├── screens/
│   └── home_screen.dart       # HomeScreen with all state & logic
│
├── widgets/
│   ├── progress_card.dart     # Today's Progress card UI
│   └── task_tile.dart         # Individual task tile (Dismissible + Card)
│
├── services/
│   └── hive_service.dart      # Hive load/save methods
│
└── data/
    └── app_data.dart          # Subjects list
```

---

## 🧠 How It Works

1. On app launch, Hive initializes and loads saved tasks from local storage
2. Tasks are displayed in a scrollable list with a checkbox, title, and subject label
3. A **Progress Card** at the top shows how many tasks are done and a circular % indicator
4. Tapping the **+** FAB opens a dialog to enter a task title and choose a subject
5. Checking the checkbox marks a task as complete (strikethrough) and persists the change
6. Swiping a task to the left deletes it and updates local storage

---

## 👤 Author

**Harikrishna P**
- GitHub: [@SneakyShadowgit](https://github.com/SneakyShadowgit)

---

> Made with ❤️ using Flutter
