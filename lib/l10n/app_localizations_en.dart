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
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get allDifficulties => 'All levels';

  @override
  String get categories => 'Categories';

  @override
  String get liveTrivia => 'Live trivia';

  @override
  String get offlineQuizzes => 'Offline quizzes';

  @override
  String get onlineQuestions => 'Fresh online questions';

  @override
  String get openTriviaAttribution =>
      'Questions from Open Trivia DB · CC BY-SA 4.0';

  @override
  String get viewLicense => 'View license';

  @override
  String get loadingQuestions => 'Finding fresh questions…';

  @override
  String get questionLoadFailure =>
      'Fresh questions are unavailable. Check your connection and try again.';

  @override
  String get noMatchingQuestions =>
      'There are not enough questions for this selection. Try another level or length.';

  @override
  String get dailyOfflineFallback =>
      'Live questions are unavailable, so today\'s quiz uses offline questions.';

  @override
  String get continueQuiz => 'Continue quiz';

  @override
  String continueQuizDescription(int current, int total) {
    return 'Your last session is saved at question $current of $total.';
  }

  @override
  String get resumeQuiz => 'Resume';

  @override
  String get dailyQuiz => 'Daily quiz';

  @override
  String get dailyQuizDescription => 'Five questions selected for today.';

  @override
  String get dailyCompleted => 'Completed today';

  @override
  String get startDailyQuiz => 'Start daily quiz';

  @override
  String dayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String get practiceIncorrect => 'Practice incorrect answers';

  @override
  String practiceIncorrectDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return 'Review $_temp0 that still need work.';
  }

  @override
  String get bookmarkedQuestions => 'Bookmarked questions';

  @override
  String bookmarkedDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved questions',
      one: '1 saved question',
    );
    return 'Practice $_temp0.';
  }

  @override
  String get noIncorrectQuestions =>
      'Complete a quiz to build your practice list.';

  @override
  String get noBookmarkedQuestions =>
      'Bookmark questions during a quiz to practice them here.';

  @override
  String get progressDashboard => 'Progress dashboard';

  @override
  String get viewProgress => 'View progress';

  @override
  String get quizSetup => 'Quiz setup';

  @override
  String get customizeQuiz =>
      'Choose the level, length, and pace for this session.';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get questionCountTitle => 'Number of questions';

  @override
  String get allQuestions => 'All questions';

  @override
  String get quizMode => 'Quiz mode';

  @override
  String get relaxedMode => 'Relaxed';

  @override
  String get relaxedModeDescription => 'Take your time and focus on learning.';

  @override
  String get timedMode => 'Timed';

  @override
  String timedModeDescription(int seconds) {
    return 'You have $seconds seconds for each question.';
  }

  @override
  String get beginQuiz => 'Begin quiz';

  @override
  String secondsRemaining(int seconds) {
    return '${seconds}s remaining';
  }

  @override
  String get timeExpired => 'Time expired';

  @override
  String get saveAndExit => 'Save and exit';

  @override
  String get abandonQuiz => 'Abandon quiz';

  @override
  String get quitQuizMessageSaved =>
      'Save your progress to continue later, or abandon this session.';

  @override
  String get bookmarkQuestion => 'Bookmark question';

  @override
  String get removeBookmark => 'Remove bookmark';

  @override
  String get progress => 'Progress';

  @override
  String get overview => 'Overview';

  @override
  String get attempts => 'Attempts';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get correctAnswersStat => 'Correct answers';

  @override
  String get dailyStreak => 'Daily streak';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get categoryPerformance => 'Category performance';

  @override
  String get noHistory => 'Complete your first quiz to see progress here.';

  @override
  String get achievements => 'Achievements';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get locked => 'Locked';

  @override
  String get achievementFirstQuiz => 'First step';

  @override
  String get achievementFirstQuizDescription => 'Complete your first quiz.';

  @override
  String get achievementPerfectScore => 'Perfect score';

  @override
  String get achievementPerfectScoreDescription =>
      'Finish a quiz with every answer correct.';

  @override
  String get achievementFiveQuizzes => 'Building momentum';

  @override
  String get achievementFiveQuizzesDescription => 'Complete five quizzes.';

  @override
  String get achievementCategoryExplorer => 'Category explorer';

  @override
  String get achievementCategoryExplorerDescription =>
      'Answer questions from three different categories.';

  @override
  String get achievementThreeDayStreak => 'Three-day streak';

  @override
  String get achievementThreeDayStreakDescription =>
      'Complete the daily quiz three days in a row.';

  @override
  String get categoryQuiz => 'Category quiz';

  @override
  String get incorrectPractice => 'Incorrect practice';

  @override
  String get bookmarkPractice => 'Bookmark practice';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderDescription =>
      'Get a local reminder to complete the daily quiz.';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get notificationsUnavailable =>
      'Scheduled reminders are available in the Android, iOS, and macOS apps.';

  @override
  String get notificationPermissionDenied =>
      'Notification permission was not granted.';

  @override
  String get dailyReminderTitle => 'Your daily Quizle is ready';

  @override
  String get dailyReminderBody =>
      'Keep your streak going with five quick questions.';

  @override
  String bestScorePercent(int percent) {
    return 'Best: $percent%';
  }

  @override
  String scorePercent(int percent) {
    return '$percent%';
  }

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get continueLabel => 'Continue';

  @override
  String get skipTour => 'Skip the tour';

  @override
  String get startExploring => 'Start exploring';

  @override
  String get backToWebsite => 'Back to website';

  @override
  String get saveFailure =>
      'We could not save your preference. Please try again.';

  @override
  String onboardingStep(int current, int total) {
    return '$current of $total';
  }

  @override
  String get onboardingDiscoverEyebrow => 'BUILT AROUND YOUR CURIOSITY';

  @override
  String get onboardingDiscoverTitle =>
      'A better quiz starts with a better question';

  @override
  String get onboardingDiscoverDescription =>
      'Explore fresh trivia across focused categories, with dependable offline quizzes ready whenever the connection is not.';

  @override
  String get onboardingLiveCategories => '8 live categories';

  @override
  String get onboardingBilingual => 'Arabic and English';

  @override
  String get onboardingOfflineReady => 'Offline ready';

  @override
  String get onboardingPersonalizeEyebrow => 'YOUR SESSION, YOUR RULES';

  @override
  String get onboardingPersonalizeTitle => 'Make every session fit the moment';

  @override
  String get onboardingPersonalizeDescription =>
      'Choose the difficulty, number of questions, and pace before you begin. Take your time or add a timer when you want a challenge.';

  @override
  String get onboardingChooseLevel => 'Choose a level';

  @override
  String get onboardingPickLength => 'Pick a length';

  @override
  String get onboardingSetPace => 'Set the pace';

  @override
  String get onboardingProgressEyebrow => 'PROGRESS YOU CAN USE';

  @override
  String get onboardingProgressTitle =>
      'Practice what matters and see what improves';

  @override
  String get onboardingProgressDescription =>
      'Return to missed or bookmarked questions, keep a daily streak, and use your history to decide what to practice next.';

  @override
  String get onboardingSavedQuestions => 'Saved questions';

  @override
  String get onboardingMistakePractice => 'Mistake practice';

  @override
  String get onboardingDailyStreaks => 'Daily streaks';

  @override
  String get openQuizle => 'Open Quizle';

  @override
  String get startLearning => 'Start learning';

  @override
  String get seeHowItWorks => 'See how it works';

  @override
  String get noAccountRequired => 'No account required';

  @override
  String get arabicAndEnglish => 'Arabic and English';

  @override
  String get offlineReady => 'Offline ready';

  @override
  String get landingHeroEyebrow => 'LEARNING THAT FITS YOUR DAY';

  @override
  String get landingHeroTitle => 'Turn a few spare minutes into real progress.';

  @override
  String get landingHeroDescription =>
      'Quizle brings fresh trivia, focused practice, and meaningful progress tracking to web, mobile, and desktop.';

  @override
  String get landingPreviewGreeting => 'Ready for a quick challenge?';

  @override
  String get landingPreviewDescription =>
      'Your next quiz is only five questions away.';

  @override
  String get landingDayStreak => 'day streak';

  @override
  String get freshQuestions => 'fresh questions';

  @override
  String get liveCategories => 'live categories';

  @override
  String get interfaceLanguages => 'interface languages';

  @override
  String get requiredAccounts => 'required accounts';

  @override
  String get landingFeaturesEyebrow => 'BUILT FOR REAL PROGRESS';

  @override
  String get landingFeaturesTitle => 'More than a list of questions';

  @override
  String get landingFeaturesDescription =>
      'Every part of Quizle helps you start quickly, learn from each answer, and return with a clear next step.';

  @override
  String get landingFreshTitle => 'Fresh questions, dependable fallback';

  @override
  String get landingFreshDescription =>
      'Explore live trivia when connected and continue with bundled quizzes when you are offline.';

  @override
  String get landingFlexibleTitle => 'A session that fits your time';

  @override
  String get landingFlexibleDescription =>
      'Set the topic, difficulty, length, and pace before each quiz.';

  @override
  String get landingPracticeTitle => 'Practice where it counts';

  @override
  String get landingPracticeDescription =>
      'Bookmark useful questions and revisit answers that still need work.';

  @override
  String get landingProgressTitle => 'Progress with context';

  @override
  String get landingProgressDescription =>
      'See accuracy, history, streaks, achievements, and category-level performance.';

  @override
  String get landingPlatformsEyebrow => 'ONE EXPERIENCE, EVERY SCREEN';

  @override
  String get landingPlatformsTitle => 'Designed for web, app, and desktop';

  @override
  String get landingPlatformsDescription =>
      'The same focused learning experience adapts naturally to the screen in front of you.';

  @override
  String get webPlatform => 'Web';

  @override
  String get webPlatformDescription =>
      'Open Quizle instantly in a modern browser and keep your progress on that device.';

  @override
  String get mobilePlatform => 'Mobile app';

  @override
  String get mobilePlatformDescription =>
      'A focused touch experience for quick sessions, daily practice, and local reminders.';

  @override
  String get desktopPlatform => 'Desktop';

  @override
  String get desktopPlatformDescription =>
      'A spacious layout for longer practice sessions across macOS, Windows, and Linux.';

  @override
  String get landingCtaTitle => 'Your next question is waiting';

  @override
  String get landingCtaDescription =>
      'Start with a short introduction, choose a category, and make today’s spare minutes count.';
}
