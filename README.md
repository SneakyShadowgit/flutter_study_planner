# 📚 Study Planner

A simple yet effective **Flutter study task manager** that helps you organize and track your daily study goals. Tasks are persisted locally using **Hive**, so your data is always saved between sessions.

---

## ✨ Features

- ✅ **Add Tasks** — Quickly add new study tasks via a dialog popup
- ☑️ **Mark as Complete** — Check off tasks with a tap; completed tasks are shown with a strikethrough
- 🗑️ **Swipe to Delete** — Swipe a task left to remove it with a confirmation snackbar
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
   git clone https://github.com/SneakyShadowgit/study_planner.git
   cd study_planner
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
study_planner/
├── lib/
│   └── main.dart          # App entry point, UI & business logic
├── android/               # Android platform files
├── ios/                   # iOS platform files
├── windows/               # Windows platform files
├── linux/                 # Linux platform files
├── macos/                 # macOS platform files
├── web/                   # Web platform files
├── test/                  # Unit & widget tests
└── pubspec.yaml           # Project dependencies & metadata
```

---

## 🧠 How It Works

1. On app launch, Hive initializes and loads saved tasks from local storage
2. Tasks are displayed in a scrollable list with a checkbox and title
3. Tapping the **+** FAB opens a dialog to enter a new task
4. Checking the checkbox marks a task as complete and persists the change
5. Swiping a task to the left deletes it and updates local storage


---

## 👤 Author

**Harikrishna P**
- GitHub: [@SneakyShadowgit](https://github.com/SneakyShadowgit)

---

> Made with ❤️ using Flutter
