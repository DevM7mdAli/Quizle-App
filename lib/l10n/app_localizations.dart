import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Quizle'**
  String get appName;

  /// No description provided for @homeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'LEARN WITH QUICK QUIZZES'**
  String get homeEyebrow;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Test your technology knowledge'**
  String get homeTitle;

  /// No description provided for @homeDescription.
  ///
  /// In en, this message translates to:
  /// **'Short bilingual quizzes with clear feedback and explanations.'**
  String get homeDescription;

  /// No description provided for @availableQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Available quizzes'**
  String get availableQuizzes;

  /// No description provided for @questionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No questions} =1{1 question} other{{count} questions}}'**
  String questionsCount(int count);

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get bestScore;

  /// No description provided for @notPlayedYet.
  ///
  /// In en, this message translates to:
  /// **'Not played yet'**
  String get notPlayedYet;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start quiz'**
  String get startQuiz;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @chooseAnswer.
  ///
  /// In en, this message translates to:
  /// **'Choose one answer'**
  String get chooseAnswer;

  /// No description provided for @submitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check answer'**
  String get submitAnswer;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get nextQuestion;

  /// No description provided for @seeResults.
  ///
  /// In en, this message translates to:
  /// **'See results'**
  String get seeResults;

  /// No description provided for @correctAnswerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswerFeedback;

  /// No description provided for @incorrectAnswerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Not quite'**
  String get incorrectAnswerFeedback;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// No description provided for @quitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quit quiz?'**
  String get quitQuiz;

  /// No description provided for @quitQuizMessage.
  ///
  /// In en, this message translates to:
  /// **'Your answers from this session will be lost.'**
  String get quitQuizMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @excellentResult.
  ///
  /// In en, this message translates to:
  /// **'Excellent work'**
  String get excellentResult;

  /// No description provided for @goodResult.
  ///
  /// In en, this message translates to:
  /// **'Good progress'**
  String get goodResult;

  /// No description provided for @practiceResult.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing'**
  String get practiceResult;

  /// No description provided for @scoreSummary.
  ///
  /// In en, this message translates to:
  /// **'You answered {score} of {total} questions correctly.'**
  String scoreSummary(int score, int total);

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review answers'**
  String get reviewAnswers;

  /// No description provided for @retryQuiz.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryQuiz;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backHome;

  /// No description provided for @answerReview.
  ///
  /// In en, this message translates to:
  /// **'Answer review'**
  String get answerReview;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get yourAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswer;

  /// No description provided for @notAnswered.
  ///
  /// In en, this message translates to:
  /// **'Not answered'**
  String get notAnswered;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used throughout the app.'**
  String get languageDescription;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get followSystem;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how Quizle looks on this device.'**
  String get appearanceDescription;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @loadingQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Loading quizzes'**
  String get loadingQuizzes;

  /// No description provided for @loadFailure.
  ///
  /// In en, this message translates to:
  /// **'We could not load the quizzes.'**
  String get loadFailure;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @quizUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This quiz is not available.'**
  String get quizUnavailable;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @allDifficulties.
  ///
  /// In en, this message translates to:
  /// **'All levels'**
  String get allDifficulties;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @liveTrivia.
  ///
  /// In en, this message translates to:
  /// **'Live trivia'**
  String get liveTrivia;

  /// No description provided for @offlineQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Offline quizzes'**
  String get offlineQuizzes;

  /// No description provided for @onlineQuestions.
  ///
  /// In en, this message translates to:
  /// **'Fresh online questions'**
  String get onlineQuestions;

  /// No description provided for @openTriviaAttribution.
  ///
  /// In en, this message translates to:
  /// **'Questions from Open Trivia DB · CC BY-SA 4.0'**
  String get openTriviaAttribution;

  /// No description provided for @viewLicense.
  ///
  /// In en, this message translates to:
  /// **'View license'**
  String get viewLicense;

  /// No description provided for @loadingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Finding fresh questions…'**
  String get loadingQuestions;

  /// No description provided for @questionLoadFailure.
  ///
  /// In en, this message translates to:
  /// **'Fresh questions are unavailable. Check your connection and try again.'**
  String get questionLoadFailure;

  /// No description provided for @noMatchingQuestions.
  ///
  /// In en, this message translates to:
  /// **'There are not enough questions for this selection. Try another level or length.'**
  String get noMatchingQuestions;

  /// No description provided for @dailyOfflineFallback.
  ///
  /// In en, this message translates to:
  /// **'Live questions are unavailable, so today\'s quiz uses offline questions.'**
  String get dailyOfflineFallback;

  /// No description provided for @continueQuiz.
  ///
  /// In en, this message translates to:
  /// **'Continue quiz'**
  String get continueQuiz;

  /// No description provided for @continueQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Your last session is saved at question {current} of {total}.'**
  String continueQuizDescription(int current, int total);

  /// No description provided for @resumeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeQuiz;

  /// No description provided for @dailyQuiz.
  ///
  /// In en, this message translates to:
  /// **'Daily quiz'**
  String get dailyQuiz;

  /// No description provided for @dailyQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Five questions selected for today.'**
  String get dailyQuizDescription;

  /// No description provided for @dailyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get dailyCompleted;

  /// No description provided for @startDailyQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start daily quiz'**
  String get startDailyQuiz;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak yet} =1{1 day streak} other{{count} day streak}}'**
  String dayStreak(int count);

  /// No description provided for @practiceIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Practice incorrect answers'**
  String get practiceIncorrect;

  /// No description provided for @practiceIncorrectDescription.
  ///
  /// In en, this message translates to:
  /// **'Review {count, plural, =1{1 question} other{{count} questions}} that still need work.'**
  String practiceIncorrectDescription(int count);

  /// No description provided for @bookmarkedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked questions'**
  String get bookmarkedQuestions;

  /// No description provided for @bookmarkedDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice {count, plural, =1{1 saved question} other{{count} saved questions}}.'**
  String bookmarkedDescription(int count);

  /// No description provided for @noIncorrectQuestions.
  ///
  /// In en, this message translates to:
  /// **'Complete a quiz to build your practice list.'**
  String get noIncorrectQuestions;

  /// No description provided for @noBookmarkedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Bookmark questions during a quiz to practice them here.'**
  String get noBookmarkedQuestions;

  /// No description provided for @progressDashboard.
  ///
  /// In en, this message translates to:
  /// **'Progress dashboard'**
  String get progressDashboard;

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'View progress'**
  String get viewProgress;

  /// No description provided for @quizSetup.
  ///
  /// In en, this message translates to:
  /// **'Quiz setup'**
  String get quizSetup;

  /// No description provided for @customizeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Choose the level, length, and pace for this session.'**
  String get customizeQuiz;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @questionCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Number of questions'**
  String get questionCountTitle;

  /// No description provided for @allQuestions.
  ///
  /// In en, this message translates to:
  /// **'All questions'**
  String get allQuestions;

  /// No description provided for @quizMode.
  ///
  /// In en, this message translates to:
  /// **'Quiz mode'**
  String get quizMode;

  /// No description provided for @relaxedMode.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get relaxedMode;

  /// No description provided for @relaxedModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Take your time and focus on learning.'**
  String get relaxedModeDescription;

  /// No description provided for @timedMode.
  ///
  /// In en, this message translates to:
  /// **'Timed'**
  String get timedMode;

  /// No description provided for @timedModeDescription.
  ///
  /// In en, this message translates to:
  /// **'You have {seconds} seconds for each question.'**
  String timedModeDescription(int seconds);

  /// No description provided for @beginQuiz.
  ///
  /// In en, this message translates to:
  /// **'Begin quiz'**
  String get beginQuiz;

  /// No description provided for @secondsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s remaining'**
  String secondsRemaining(int seconds);

  /// No description provided for @timeExpired.
  ///
  /// In en, this message translates to:
  /// **'Time expired'**
  String get timeExpired;

  /// No description provided for @saveAndExit.
  ///
  /// In en, this message translates to:
  /// **'Save and exit'**
  String get saveAndExit;

  /// No description provided for @abandonQuiz.
  ///
  /// In en, this message translates to:
  /// **'Abandon quiz'**
  String get abandonQuiz;

  /// No description provided for @quitQuizMessageSaved.
  ///
  /// In en, this message translates to:
  /// **'Save your progress to continue later, or abandon this session.'**
  String get quitQuizMessageSaved;

  /// No description provided for @bookmarkQuestion.
  ///
  /// In en, this message translates to:
  /// **'Bookmark question'**
  String get bookmarkQuestion;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @correctAnswersStat.
  ///
  /// In en, this message translates to:
  /// **'Correct answers'**
  String get correctAnswersStat;

  /// No description provided for @dailyStreak.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get dailyStreak;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @categoryPerformance.
  ///
  /// In en, this message translates to:
  /// **'Category performance'**
  String get categoryPerformance;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'Complete your first quiz to see progress here.'**
  String get noHistory;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @achievementFirstQuiz.
  ///
  /// In en, this message translates to:
  /// **'First step'**
  String get achievementFirstQuiz;

  /// No description provided for @achievementFirstQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your first quiz.'**
  String get achievementFirstQuizDescription;

  /// No description provided for @achievementPerfectScore.
  ///
  /// In en, this message translates to:
  /// **'Perfect score'**
  String get achievementPerfectScore;

  /// No description provided for @achievementPerfectScoreDescription.
  ///
  /// In en, this message translates to:
  /// **'Finish a quiz with every answer correct.'**
  String get achievementPerfectScoreDescription;

  /// No description provided for @achievementFiveQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Building momentum'**
  String get achievementFiveQuizzes;

  /// No description provided for @achievementFiveQuizzesDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete five quizzes.'**
  String get achievementFiveQuizzesDescription;

  /// No description provided for @achievementCategoryExplorer.
  ///
  /// In en, this message translates to:
  /// **'Category explorer'**
  String get achievementCategoryExplorer;

  /// No description provided for @achievementCategoryExplorerDescription.
  ///
  /// In en, this message translates to:
  /// **'Answer questions from three different categories.'**
  String get achievementCategoryExplorerDescription;

  /// No description provided for @achievementThreeDayStreak.
  ///
  /// In en, this message translates to:
  /// **'Three-day streak'**
  String get achievementThreeDayStreak;

  /// No description provided for @achievementThreeDayStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete the daily quiz three days in a row.'**
  String get achievementThreeDayStreakDescription;

  /// No description provided for @categoryQuiz.
  ///
  /// In en, this message translates to:
  /// **'Category quiz'**
  String get categoryQuiz;

  /// No description provided for @incorrectPractice.
  ///
  /// In en, this message translates to:
  /// **'Incorrect practice'**
  String get incorrectPractice;

  /// No description provided for @bookmarkPractice.
  ///
  /// In en, this message translates to:
  /// **'Bookmark practice'**
  String get bookmarkPractice;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Get a local reminder to complete the daily quiz.'**
  String get dailyReminderDescription;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @notificationsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scheduled reminders are available in the Android, iOS, and macOS apps.'**
  String get notificationsUnavailable;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was not granted.'**
  String get notificationPermissionDenied;

  /// No description provided for @dailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily Quizle is ready'**
  String get dailyReminderTitle;

  /// No description provided for @dailyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak going with five quick questions.'**
  String get dailyReminderBody;

  /// No description provided for @bestScorePercent.
  ///
  /// In en, this message translates to:
  /// **'Best: {percent}%'**
  String bestScorePercent(int percent);

  /// No description provided for @scorePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String scorePercent(int percent);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
