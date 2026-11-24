# Spendly

Personal Expense Tracker · Flutter Mobile Application Development · Final Project

## 1. Project Description

Spendly is a local-first personal expense tracker for Android, built with Flutter and Dart. It lets a user record everyday spending, assign each record to one of seven fixed categories, track a monthly budget, and understand where the money went through a monthly summary, a category breakdown, and a chronological expense list. All data is stored on the device using SQLite, and the budget setting is stored with SharedPreferences. The application requires no account, no internet connection, and no cloud service.

## 2. Purpose

The purpose of Spendly is to give students and young professionals a fast, private way to record daily expenses and see the month at a glance. Recording an expense takes a few seconds, the monthly total and budget status are visible on the home screen, and every record can be reviewed, edited, or deleted. Because the data stays on the phone, the application demonstrates local data management as required by the course while remaining useful in daily life.

## 3. Problem Addressed

- Daily spending is often not recorded because trackers require many fields, an account, or an internet connection, so the habit is abandoned within days.
- Students and young professionals working with a fixed allowance need to know how much of the monthly budget is left without doing manual arithmetic.
- Without category totals, it is difficult to notice which kind of spending consumes most of the budget.
- Cloud based applications store personal financial data on remote servers and stop working offline.

## 4. Target Users

- Students and young professionals with a fixed monthly allowance or salary who budget manually.
- Filipino users who think in pesos and need a lightweight, offline tool with no sign-up.
- Privacy conscious users who prefer personal spending records to stay on their own device.
- Beginners who want a simple interface: one add button, one list, one monthly summary, no configuration.

## 5. Application Features

### 5.1 Core Expense Management

| Code | Feature | Description | Screen |
|---|---|---|---|
| F1 | Create expense | Records a title, amount, category, date and an optional note. | Add |
| F2 | Browse all expenses | Lists every saved record newest first, grouped by day. | Expenses |
| F3 | View one expense | Shows the full record: amount, title, category, dates and note. | Details |
| F4 | Update expense | Reopens the same form prefilled with the saved values. | Edit |
| F5 | Delete expense | Asks for confirmation, then permanently removes the record. | Details |
| F6 | Persistent storage | All records are kept in an on-device SQLite database and survive restarts. | Data layer |
| F7 | Monthly budget | A user-defined limit stored in SharedPreferences, default 10,000 pesos. | Home |
| F8 | Budget progress | Progress bar, percentage used and remaining balance in pesos. | Home |
| F9 | Over-budget warning | A highlighted chip reading "Over budget by X pesos" and a bar that changes colour. | Home |
| F10 | Month summary | Total spent this month plus the number of records. | Home |
| F11 | Category breakdown | Per-category totals and percentage share, largest first; empty categories hidden. | Home |
| F12 | Recent expenses | The four most recent records with a "See all" shortcut to the Expenses tab. | Home |
| F13 | Pull-to-refresh | Re-reads data from SQLite on demand. | Home, Expenses |
| F14 | Empty states | Explanatory card with an "Add expense" action instead of a blank screen. | Home, Expenses |
| F15 | Action feedback | Confirmation messages after adding, updating, deleting or changing the budget. | All |
| F16 | Day grouping | Headers read Today, Yesterday or the weekday date, each with a daily subtotal. | Expenses |
| F17 | Count and grand total | For example "12 expenses · 4,820.50 pesos total". | Expenses |

### 5.2 Forms and Validation

| Code | Feature | Description |
|---|---|---|
| F18 | Required-field validation | Title, amount, category and date are enforced with inline messages. |
| F19 | Title rules | Required, minimum 3 characters, maximum 60. |
| F20 | Amount rules | Numeric input only, must be greater than zero, decimals accepted. |
| F21 | Category selection | Seven choices shown as chips with icons; a missing category shows its own error. |
| F22 | Date picker | Read-only field opening a calendar limited to the last five years, with no future dates. |
| F23 | Note rules | Optional, multiline, maximum 200 characters. |
| F24 | Save-in-progress state | The button disables and shows a spinner to prevent duplicate records. |
| F25 | Invalid-submit feedback | A haptic cue and all errors shown in a single pass. |
| F26 | Prefilled edit form | Every field loads the stored value when editing. |

### 5.3 Navigation and Screens

| Code | Feature | Description |
|---|---|---|
| F27 | Splash screen | A 1.6-second branded opening with a fade-and-rise animation; it cannot be returned to. |
| F28 | Three-tab shell | Home, Expenses and About through a bottom navigation bar. |
| F29 | Fade page transitions | Used when opening Add, Edit and Details. |
| F30 | Fresh data on tab switch | Screens rebuild so totals are never stale. |
| F31 | About screen | App identity and version, technology note, four-step usage guide, privacy statement and team list. |

### 5.4 Data and Technical Implementation

| Code | Feature | Description |
|---|---|---|
| F32 | Database schema | One expenses table with title, amount, category, date, note and creation timestamp; amount must be positive; the date column is indexed. |
| F33 | Single data gateway | One shared database connection for the whole app. |
| F34 | Aggregate queries | Totals, counts and category sums are computed by SQL, not in Dart. |
| F35 | Seven fixed categories | Food, Transport, Bills, Shopping, Health, Entertainment, Others; unrecognised values fall back to Others. |
| F36 | Money formatting | Philippine peso with thousands separators and two decimals. |
| F37 | Date formatting | Short date, full date, month-and-year, and relative day labels. |
| F38 | Time-of-day greeting | Morning, afternoon or evening on Home. |
| F39 | Design system | Plus Jakarta Sans in five weights, Material 3, and centralised colour, spacing and text tokens. |
| F40 | Reusable widgets | Shared card, expense row, category badge, empty state, section header and budget dialog. |
| F41 | State management | setState with asynchronous loads guarded against disposed screens. |
| F42 | Automated tests | Six tests covering data conversion, category fallback, copy behaviour and form validation. |

## 6. Required Screens and Their Implementation

| Required Screen | Implementation |
|---|---|
| Splash or Welcome | `splash_screen.dart` (F27) |
| Home | Home tab: summary, budget, category breakdown, recent records (F7 to F12) |
| Main Management | Expenses tab: grouped list with daily subtotals (F13 to F17) |
| Add Record | `ExpenseFormScreen` opened without an existing expense |
| Edit Record | `ExpenseFormScreen` opened with an existing expense |
| Details | `expense_details_screen.dart` (F3 and F5) |
| About | About tab (F31) |

## 7. Scope and Limitations

The following are intentionally outside version 1.0.0 and are listed as future work: user accounts and sign-in; cloud sync or backup; CSV or PDF export; search and filtering; custom or editable categories; recurring expenses; charts beyond the category breakdown; multiple currencies; localisation; dark mode.

## 8. System Flowchart Outline

- Start, then Splash screen (1.6 seconds) then Home tab.
- Home branches to: Expenses tab, About tab, Add expense, Details of a recent expense, Edit budget dialog.
- Expenses tab branches to: Add expense, Details of a selected expense.
- Add and Edit both lead to Save, which validates input and writes to the SQLite table, then returns to the previous screen.
- Details branches to: Edit expense (returns to Details) and Delete (confirmation dialog, then returns to the list).
- Data layer: SQLite database for expense records, SharedPreferences for the monthly budget.

## 9. Group Members and Responsibilities

Group roles follow Section VII of the final project guidelines. The group has six members, so the functionality and testing responsibility and the documentation and quality assurance responsibility are combined for one member, as the guidelines allow.

| Member | PDF Role | Main Responsibility |
|---|---|---|
| Gonzaga, Cedrick | Project Leader | Overall coordination, planning and progress monitoring; oversight of the full build from proposal to final demonstration. |
| Dungo, Mitch | Frontend Developer | Flutter widgets and screen development: splash, home, expense list, details, add and edit forms. |
| De Chavez, Gerard Cyr | UI/UX Designer | Interface layout, colours and visual design: Figma wireframes, palette, typography and component set. |
| Ramirez, Jay Darrius | Navigation Developer | Screen navigation and application flow: tab shell, page transitions, flow between list, details and forms. |
| Bernales, Remier Marc | Backend/Data Developer | CRUD operations and local data storage: SQLite schema and queries, SharedPreferences budget storage. |
| Melia, Juleto Jaycee | Functionality and Testing; Documentation and Quality Assurance | Feature integration, testing and debugging; documentation, screenshots and presentation preparation. |

All members contributed to testing and to the final demonstration. Group roles describe main responsibility, not exclusive ownership.
