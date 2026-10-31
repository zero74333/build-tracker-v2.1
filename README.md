# Zeeshan Daily Life Style

An offline-first personal life tracker built with Flutter. The interface is organised as a dashboard of separate, icon-based spaces instead of one long form. Data is stored locally in SQLite.

## Dashboard sections

- **Daily Log** — day overview, priorities, reflection, moral of the day and tomorrow preparation.
- **Health & Body** — sleep, meals and intake, gut health, movement, symptoms and body notes.
- **Mind & Mood** — mood, mental energy, anxiety, stress, calming practices and reflection.
- **Ideaverse** — idea inbox, pinned idea, realizations, recurring thoughts, learnings, questions, quotes and brain dump.
- **Work & Learning** — tasks, focus sessions, study and practice, output, goals and blockers.
- **Money** — income, expenses, savings, bills and money reflections.
- **Relationships & Social** — interactions, social energy, support, conflict and boundaries.
- **Habits & Routines** — daily habits, screen time, habits to build or break and routines.
- **Activities & Experiences** — major activities, unexpected events, gap-filling activities, practice, new experiences, memories and time allocation.

Each space opens in its own screen. Subsections are separated into collapsible cards. Repeating records such as ideas, tasks, expenses, interactions and activities can be added, edited and deleted individually. Edits are automatically saved after a short pause, with a manual save control whenever there are unsaved changes. Text inputs have explicit compact / multiline size limits so one field cannot expand to fill the screen. Single-line fields use a compact 62-pixel height; long-text fields use a bounded 140-pixel writing area. The section editor shows autosave state, supports manual retry after a failed save, and provides empty states for repeatable lists.

The app also includes history, a basic seven-record insights view, quick capture to the Ideaverse inbox, Markdown export and JSON backup/restore.

## Data and privacy

The app works without an internet connection. Daily records are stored in the phone's SQLite database (`tracker.db`). There is no account, cloud service or automatic device sync. Export a JSON backup regularly and keep a copy outside the phone. Restoring a backup merges dates into the current database; values from the imported backup replace matching fields on the same date.

The app keeps the previous database name and table structure (`tracker.db`, `days`) and preserves the earlier tracker field keys where applicable. This is intended to make an in-place APK update retain existing records when the Android application ID remains the same as the previous build.

## Build the APK with GitHub Actions

This repository is configured to build the Android APK on pushes and pull requests to `main`, or manually from the Actions tab.

1. Create or open the GitHub repository named `building-tracker`.
2. Upload the **contents** of this project folder to the repository root. Make sure the hidden `.github` folder is included.
3. Commit the files to the `main` branch.
4. Open **Actions** and select **Build Android APK**.
5. When the workflow succeeds, open the workflow run and download the artifact named `zeeshan-daily-life-style-apk`.
6. Extract the ZIP and install `app-release.apk` on the Android phone. Android may ask you to allow installation from the file manager or browser used to open the APK.

The workflow uses Flutter 3.47.9 with its bundled Dart 3.13.7 and Java 17. Widget tests exercise compact single-line fields, bounded multiline writing areas and multi-choice input; they avoid references to the default Flutter starter app. It generates the Android platform folder with the defaults from that Flutter template, installs and verifies Android Platform 36, Build Tools 36.0.0 and NDK 28.2.13676358, generates the launcher icon from `assets/icon.png`, runs Dart formatting, static analysis and tests, and then builds the release APK. The Flutter template supplies compile SDK 36, target SDK 36 and minimum SDK 24; the workflow does not force SDK values through a Gradle init script. Android Studio is not required on your PC.

To rebuild without changing the source, use **Actions → Build Android APK → Run workflow**.

## Project layout

```text
assets/icon.png
lib/
  main.dart
  data/
    database.dart
    export_service.dart
    fields.dart
  screens/
    dashboard_screen.dart
    export_screen.dart
    field_input.dart
    history_screen.dart
    home_screen.dart
    insights_screen.dart
    section_screen.dart
test/schema_test.dart
test/widget_test.dart
.github/workflows/build-apk.yml
docs/life-tracker-v4.md
docs/original-project-notes.txt
```

## Important limitations

- There is no PC-to-phone sync. Use JSON backup/restore to move data.
- CI does not yet use a persistent private release keystore. Back up your JSON data before replacing an installed APK; an APK signed by a different CI key cannot update the existing installation. A persistent keystore must be configured through GitHub Actions secrets for reliable in-place upgrades.
- Reminders, app lock, attachments/photos, biometric protection and configurable master-data lists are not implemented in this version.
- Time and date fields are text inputs so they can be entered quickly and consistently.
- The insights view is descriptive, not medical or financial advice.
- The master-data editor, custom tags, photo/voice attachments, PIN or biometric app lock, and scheduled reminders are not included yet.
- Some values that the original specification described as automatic (for example, financial totals and time-allocation totals) are entered manually in this build.
