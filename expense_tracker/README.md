# Expense Tracker

A local-first personal expense tracker built with Flutter, Dart and SQLite for
the Mobile Development final project.

## Features

- **Create, read, update, delete** expenses (title, amount, category, date, note)
- **Seven screens**: Splash, Home, Expense List, Add, Edit, Details, About
- **Form validation**: empty/short title, empty or non-numeric amount, amount
  `<= 0`, missing category, missing date
- **Conditional logic**: monthly total, per-category totals, monthly budget with
  an over-budget warning, empty states
- **Local storage only**: expenses in SQLite (`sqflite`), monthly budget in
  `SharedPreferences`; works fully offline
- **Currency**: Philippine peso (`₱`) formatting via `intl`

## Project structure

```
lib/
├── main.dart                     app entry point
├── data/
│   ├── database_helper.dart      SQLite singleton: schema + CRUD + totals
│   └── budget_service.dart       monthly budget in SharedPreferences
├── models/
│   ├── expense.dart              record + toMap/fromMap/copyWith
│   └── expense_category.dart     7 fixed categories
├── screens/
│   ├── splash_screen.dart
│   ├── main_shell.dart           bottom navigation (Home / Expenses / About)
│   ├── home_screen.dart
│   ├── expense_list_screen.dart
│   ├── expense_form_screen.dart  add + edit
│   ├── expense_details_screen.dart
│   └── about_screen.dart
├── theme/                        colours, type scale, spacing, Material theme
├── utils/                        formatters, category visuals, fade route
└── widgets/                      AppCard, ExpenseTile, CategoryBadge, ...
```

## Database schema

```sql
CREATE TABLE expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  amount REAL NOT NULL CHECK (amount > 0),
  category TEXT NOT NULL,
  date TEXT NOT NULL,
  note TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL
);
```

Dates are stored as ISO-8601 strings, which makes monthly range queries simple
and human-readable: `WHERE date >= ? AND date < ?`.

## Design

- Typeface: **Plus Jakarta Sans** (bundled locally, no runtime download)
- Headings: bold/extra bold with tight negative tracking
- Palette: charcoal `#282A2E`, muted `#697177`, sage `#E2EFE7`, purple
  `#9A9DE5`, teal `#9CBFB4`, yellow `#FCD378`, white cards

## Run

```bash
flutter pub get
flutter run          # Android emulator or device
flutter test         # model + form validation tests
flutter analyze
flutter build apk --release
```

## Screenshots

Captured on an Android emulator (1080 × 2400) from the release build:

| | |
| --- | --- |
| ![Splash](docs/screenshots/01-splash.png) | ![Home](docs/screenshots/02-home.png) |
| Splash | Home (over-budget state) |
| ![Expense list](docs/screenshots/03-expense-list.png) | ![Add expense](docs/screenshots/04-add-expense.png) |
| Expense list, grouped by day | Add expense |
| ![Validation](docs/screenshots/05-validation.png) | ![Details](docs/screenshots/06-details.png) |
| Inline validation errors | Details |
| ![Edit](docs/screenshots/07-edit-expense.png) | ![Delete](docs/screenshots/08-delete-confirm.png) |
| Edit (same form, prefilled) | Delete confirmation |
| ![About](docs/screenshots/09-about.png) | ![Team](docs/screenshots/10-about-team.png) |
| About | About — team |

Defense preparation notes (15 likely questions answered from this code) are in
[`docs/DEFENSE_NOTES.md`](docs/DEFENSE_NOTES.md).

## Team

| Member | Role |
| --- | --- |
| Gonzaga, Cedrick | Project lead, data layer (model, SQLite, CRUD) |
| De Chavez, Gerard Cyr | UI/UX, theme, Home and List screens |
| Dungo, Mitch | Navigation, Add/Edit forms, Details screen |
| Ramirez, Jay Darrius | Logic, testing, About screen, documentation |
