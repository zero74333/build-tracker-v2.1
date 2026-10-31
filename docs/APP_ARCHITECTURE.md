# App architecture

## Navigation

The landing screen is a responsive two- or three-column dashboard. Each of the nine life areas is a separate destination. Inside a destination, its subsections are individual collapsible cards. History opens the same dashboard for a selected past date.

## Daily record model

SQLite stores one row per date in the `days` table. The `data` column contains a JSON object. This intentionally retains the original `tracker.db` database filename and `days(date, data)` table structure.

Regular fields use a stable key such as `daily.rating` or `sleep.hours`. Repeating groups use a JSON list, for example `ideaverse_idea_inbox.entries` or `work_tasks.entries`. The `fields.dart` file is the single source of truth for module labels, icons, grouped fields and storage keys. Markdown export reads the same definitions.

Existing compact-tracker keys were retained where practical so a replacement APK can read the same local database. The legacy keys for Daily Log, Sleep, Mind & Mood, Health & Body, Work & Learning, Money, Social, Habits and Activities remain represented in the current form definitions.

## Save and restore

A field edit marks the screen dirty and schedules a debounced SQLite save. Leaving a section waits for an outstanding save before allowing navigation. The JSON restore path validates date-shaped keys and merges imported dates into the local database. A matching date is merged by key, with imported values taking precedence.

## Build

GitHub Actions creates the Android platform scaffold with project name `zeeshan_daily_life_style`, organisation `com.example`, Flutter 3.47.9 and Java 17, installs/verifies Android SDK Platform 36, Build Tools 36.0.0 and NDK 28.2.13676358, generates the app launcher icon, runs `dart format`, `flutter analyze` and `flutter test`, and builds a release APK. Flutter 3.47.9's Android template uses AGP 9.1.0, Kotlin Gradle Plugin 2.4.0, Gradle 9.3.1, NDK 28.2.13676358, compile/target SDK 36 and min SDK 24. The repository does not include generated Android build output or signing credentials. The build currently uses the generated project default signing configuration; configure a persistent private release keystore before depending on in-place APK upgrades.
