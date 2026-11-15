# Mobile Development — Final Project

**Expense Tracker** — a local-first expense tracker built with Flutter, Dart,
SQLite (`sqflite`) and SharedPreferences.

- App source and documentation: [`expense_tracker/`](expense_tracker/)
- Defense notes (15 likely questions with code-level answers):
  [`expense_tracker/docs/DEFENSE_NOTES.md`](expense_tracker/docs/DEFENSE_NOTES.md)

## Quick start

```bash
cd expense_tracker
flutter pub get
flutter run          # with an emulator or device connected
```

Other commands:

```bash
flutter test         # 6 tests: model round-trip, categories, form validation
flutter analyze      # static analysis
flutter build apk --release
```

The release APK is written to
`expense_tracker/build/app/outputs/flutter-apk/app-release.apk`.

## Screens

Splash · Home · Expense List · Add · Edit · Details · About
