# Quizle

Quizle is an offline-first Flutter quiz application with English and Arabic support.

## Features

- Localized English and Arabic interface
- Right-to-left Arabic layouts
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
- Immutable domain models validate quiz content before it reaches the UI.

Quiz content is stored in `assets/content`. English and Arabic files share stable quiz, question, and option IDs so translated text never controls scoring.

## Development

Install the Flutter version supported by `pubspec.yaml`, then run:

```sh
flutter pub get
flutter gen-l10n
flutter run
```

Run the quality checks with:

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

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
