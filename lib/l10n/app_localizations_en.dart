// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Quizle';

  @override
  String get homeEyebrow => 'LEARN WITH QUICK QUIZZES';

  @override
  String get homeTitle => 'Test your technology knowledge';

  @override
  String get homeDescription =>
      'Short bilingual quizzes with clear feedback and explanations.';

  @override
  String get availableQuizzes => 'Available quizzes';

  @override
  String questionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: 'No questions',
    );
    return '$_temp0';
  }

  @override
  String get bestScore => 'Best score';

  @override
  String get notPlayedYet => 'Not played yet';

  @override
  String get startQuiz => 'Start quiz';

  @override
  String questionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get chooseAnswer => 'Choose one answer';

  @override
  String get submitAnswer => 'Check answer';

  @override
  String get nextQuestion => 'Next question';

  @override
  String get seeResults => 'See results';

  @override
  String get correctAnswerFeedback => 'Correct answer';

  @override
  String get incorrectAnswerFeedback => 'Not quite';

  @override
  String get explanation => 'Explanation';

  @override
  String get quitQuiz => 'Quit quiz?';

  @override
  String get quitQuizMessage => 'Your answers from this session will be lost.';

  @override
  String get cancel => 'Cancel';

  @override
  String get quit => 'Quit';

  @override
  String get results => 'Results';

  @override
  String get excellentResult => 'Excellent work';

  @override
  String get goodResult => 'Good progress';

  @override
  String get practiceResult => 'Keep practicing';

  @override
  String scoreSummary(int score, int total) {
    return 'You answered $score of $total questions correctly.';
  }

  @override
  String get reviewAnswers => 'Review answers';

  @override
  String get retryQuiz => 'Try again';

  @override
  String get backHome => 'Back to home';

  @override
  String get answerReview => 'Answer review';

  @override
  String get yourAnswer => 'Your answer';

  @override
  String get correctAnswer => 'Correct answer';

  @override
  String get notAnswered => 'Not answered';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageDescription =>
      'Choose the language used throughout the app.';

  @override
  String get followSystem => 'Use device language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceDescription => 'Choose how Quizle looks on this device.';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get loadingQuizzes => 'Loading quizzes';

  @override
  String get loadFailure => 'We could not load the quizzes.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get quizUnavailable => 'This quiz is not available.';

  @override
  String get beginner => 'Beginner';

  @override
  String scorePercent(int percent) {
    return '$percent%';
  }
}
