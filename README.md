# Quizle

Quizle is an offline-first Flutter quiz application with English and Arabic support.

## Features

- Localized English and Arabic interface
- Right-to-left Arabic layouts
- Persisted first-run onboarding across mobile, desktop, and web
- Public responsive web landing page
- Technology, internet safety, and programming categories
- Fresh English trivia across eight online categories
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
- Persisted onboarding, language, theme, and best scores
- Responsive Material 3 interface
- Persistent stale-while-revalidate API caching

## Architecture

The application uses feature-first MVVM boundaries:

- Views render state and forward user actions.
- Riverpod notifiers own presentation state and quiz transitions.
- Repositories isolate remote and bundled quiz content from the session engine.
- Cached Query manages remote server state, retries, and cache freshness.
- A local learning repository persists attempts, bookmarks, and resumable state.
- Immutable domain models validate quiz content before it reaches the UI.

English users receive fresh questions from Open Trivia DB. Remote responses are
cached locally and normalized into the same domain models used by the bundled
catalog. The bundled English and Arabic catalogs remain available for offline
sessions and as the daily-quiz fallback.

Structured learning data is stored locally and capped to the 200 most recent
attempts. Up to 200 remote question snapshots are retained so interrupted
sessions, bookmarks, and incorrect-answer practice work after an app restart.
No account, application backend, or analytics service is required. Scheduled
browser notifications are not enabled because browsers do not support reliable
repeating local schedules.

The web build separates the public website from the application experience.
The root route shows the product landing page, while `/app` opens Quizle. New
web users see onboarding only after choosing to open the app. Native and desktop
users see onboarding on their first launch and enter the quiz home directly on
later launches.

Remote questions are provided by
[Open Trivia DB](https://opentdb.com/) under the
[CC BY-SA 4.0 license](https://creativecommons.org/licenses/by-sa/4.0/).

## Development

Install the Flutter version supported by `pubspec.yaml`, then run:

```sh
flutter pub get
dart run husky install
flutter gen-l10n
flutter run
```

Native builds target Android API 23 or newer, iOS 13 or newer, and macOS
10.15 or newer.

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

The workflow builds with `base-href /` for the custom domain, so this project
is published at:

`https://quizle.mohammed.win/`

The deployed root is the public landing page. Flutter's hash routes keep the
application and onboarding routes compatible with static GitHub Pages hosting.

Before the first deployment, set the repository's Pages source to GitHub Actions
in **Settings > Pages**.

## Adding quiz content

Update both localized catalog files together:

- `assets/content/quizzes_en.json`
- `assets/content/quizzes_ar.json`

Every question must contain at least two unique options, and `correctOptionId` must reference one of those options. Automated parsing tests reject invalid content.
