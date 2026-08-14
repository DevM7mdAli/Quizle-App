# Quizle

Quizle is an offline-first Flutter quiz application with English and Arabic support.

## Features

- Localized English and Arabic interface
- Right-to-left Arabic layouts
- Technology, internet safety, and programming categories
- Difficulty, question-count, and quiz-mode configuration
- Timed and relaxed sessions
- Daily quiz, streaks, and achievements
- Resumable interrupted sessions
- Incorrect-answer and bookmarked-question practice
- Local progress dashboard and attempt history
- Daily local reminders on Android, iOS, and macOS
- Randomized questions and answer options
- Answer feedback and explanations
- Results and answer review
- Persisted language, theme, and best scores
- Responsive Material 3 interface

## Architecture

The application uses feature-first MVVM boundaries:

- Views render state and forward user actions.
- Riverpod notifiers own presentation state and quiz transitions.
- Repositories isolate bundled quiz content and device preferences.
- A local learning repository persists attempts, bookmarks, and resumable state.
- Immutable domain models validate quiz content before it reaches the UI.

Quiz content is stored in `assets/content`. English and Arabic files share stable quiz, question, and option IDs so translated text never controls scoring.

Structured learning data is stored locally and capped to the 200 most recent
attempts. No account, backend, analytics service, or network connection is
required. Scheduled browser notifications are not enabled because browsers do
not support reliable repeating local schedules.

## Development

Install the Flutter version supported by `pubspec.yaml`, then run:

```sh
flutter pub get
dart run husky install
flutter gen-l10n
flutter run
```

Husky installs the repository's Git hooks. The pre-commit hook checks Dart
formatting, static analysis, and tests. The commit-message hook enforces
[Conventional Commits](https://www.conventionalcommits.org/) with a 100-character
limit for the header and each body or footer line.

Use commit messages in this form:

```text
feat(quiz): add timed question mode

Keep optional body lines at or below 100 characters.
```

Run the quality checks with:

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
dart run commitlint_cli --from HEAD~1 --to HEAD
```

The `Flutter quality` workflow repeats these checks for pull requests and pushes
to `master`, so local hooks and CI enforce the same repository standard.

## Web deployment

The `Deploy Flutter web` GitHub Actions workflow validates and publishes the
web app to GitHub Pages after every push to `master`. It can also be started
manually from the Actions tab.

The workflow builds with the repository subpath automatically, so this project
is published at:

`https://devm7mdali.github.io/Quizle-App/`

Before the first deployment, set the repository's Pages source to GitHub Actions
in **Settings > Pages**.

## Adding quiz content

Update both localized catalog files together:

- `assets/content/quizzes_en.json`
- `assets/content/quizzes_ar.json`

Every question must contain at least two unique options, and `correctOptionId` must reference one of those options. Automated parsing tests reject invalid content.
