// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'كويزل';

  @override
  String get homeEyebrow => 'تعلّم باختبارات قصيرة';

  @override
  String get homeTitle => 'اختبر معرفتك التقنية';

  @override
  String get homeDescription =>
      'اختبارات قصيرة باللغتين مع ملاحظات وتفسيرات واضحة.';

  @override
  String get availableQuizzes => 'الاختبارات المتاحة';

  @override
  String questionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سؤال',
      many: '$count سؤالًا',
      few: '$count أسئلة',
      two: 'سؤالان',
      one: 'سؤال واحد',
      zero: 'لا توجد أسئلة',
    );
    return '$_temp0';
  }

  @override
  String get bestScore => 'أفضل نتيجة';

  @override
  String get notPlayedYet => 'لم يبدأ بعد';

  @override
  String get startQuiz => 'ابدأ الاختبار';

  @override
  String questionProgress(int current, int total) {
    return 'السؤال $current من $total';
  }

  @override
  String get chooseAnswer => 'اختر إجابة واحدة';

  @override
  String get submitAnswer => 'تحقق من الإجابة';

  @override
  String get nextQuestion => 'السؤال التالي';

  @override
  String get seeResults => 'عرض النتائج';

  @override
  String get correctAnswerFeedback => 'إجابة صحيحة';

  @override
  String get incorrectAnswerFeedback => 'ليست الإجابة الصحيحة';

  @override
  String get explanation => 'التفسير';

  @override
  String get quitQuiz => 'إنهاء الاختبار؟';

  @override
  String get quitQuizMessage => 'ستفقد إجابات هذه المحاولة.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get quit => 'إنهاء';

  @override
  String get results => 'النتائج';

  @override
  String get excellentResult => 'أداء ممتاز';

  @override
  String get goodResult => 'تقدم جيد';

  @override
  String get practiceResult => 'واصل التدريب';

  @override
  String scoreSummary(int score, int total) {
    return 'أجبت بشكل صحيح عن $score من أصل $total أسئلة.';
  }

  @override
  String get reviewAnswers => 'مراجعة الإجابات';

  @override
  String get retryQuiz => 'حاول مرة أخرى';

  @override
  String get backHome => 'العودة للرئيسية';

  @override
  String get answerReview => 'مراجعة الإجابات';

  @override
  String get yourAnswer => 'إجابتك';

  @override
  String get correctAnswer => 'الإجابة الصحيحة';

  @override
  String get notAnswered => 'لم تتم الإجابة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get languageDescription =>
      'اختر اللغة المستخدمة في جميع أجزاء التطبيق.';

  @override
  String get followSystem => 'استخدام لغة الجهاز';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceDescription => 'اختر مظهر كويزل على هذا الجهاز.';

  @override
  String get systemTheme => 'النظام';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get loadingQuizzes => 'جارٍ تحميل الاختبارات';

  @override
  String get loadFailure => 'تعذر تحميل الاختبارات.';

  @override
  String get tryAgain => 'أعد المحاولة';

  @override
  String get quizUnavailable => 'هذا الاختبار غير متاح.';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم';

  @override
  String get allDifficulties => 'كل المستويات';

  @override
  String get categories => 'التصنيفات';

  @override
  String get continueQuiz => 'متابعة الاختبار';

  @override
  String continueQuizDescription(int current, int total) {
    return 'حُفظت محاولتك عند السؤال $current من $total.';
  }

  @override
  String get resumeQuiz => 'متابعة';

  @override
  String get dailyQuiz => 'اختبار اليوم';

  @override
  String get dailyQuizDescription => 'خمسة أسئلة مختارة لهذا اليوم.';

  @override
  String get dailyCompleted => 'اكتمل اليوم';

  @override
  String get startDailyQuiz => 'ابدأ اختبار اليوم';

  @override
  String dayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سلسلة $count يوم',
      many: 'سلسلة $count يومًا',
      few: 'سلسلة $count أيام',
      two: 'سلسلة يومين',
      one: 'سلسلة يوم واحد',
      zero: 'لا توجد سلسلة بعد',
    );
    return '$_temp0';
  }

  @override
  String get practiceIncorrect => 'تدريب على الإجابات الخاطئة';

  @override
  String practiceIncorrectDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سؤال يحتاج إلى تدريب',
      many: '$count سؤالًا يحتاج إلى تدريب',
      few: '$count أسئلة تحتاج إلى تدريب',
      two: 'سؤالين يحتاجان إلى تدريب',
      one: 'سؤالًا واحدًا يحتاج إلى تدريب',
    );
    return 'راجع $_temp0.';
  }

  @override
  String get bookmarkedQuestions => 'الأسئلة المحفوظة';

  @override
  String bookmarkedDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سؤال محفوظ',
      many: '$count سؤالًا محفوظًا',
      few: '$count أسئلة محفوظة',
      two: 'سؤالين محفوظين',
      one: 'سؤال محفوظ',
    );
    return 'تدرّب على $_temp0.';
  }

  @override
  String get noIncorrectQuestions => 'أكمل اختبارًا لإنشاء قائمة التدريب.';

  @override
  String get noBookmarkedQuestions =>
      'احفظ الأسئلة أثناء الاختبار لتتدرب عليها هنا.';

  @override
  String get progressDashboard => 'لوحة التقدم';

  @override
  String get viewProgress => 'عرض التقدم';

  @override
  String get quizSetup => 'إعداد الاختبار';

  @override
  String get customizeQuiz => 'اختر المستوى والطول والوتيرة لهذه المحاولة.';

  @override
  String get difficulty => 'الصعوبة';

  @override
  String get questionCountTitle => 'عدد الأسئلة';

  @override
  String get allQuestions => 'كل الأسئلة';

  @override
  String get quizMode => 'نمط الاختبار';

  @override
  String get relaxedMode => 'بدون توقيت';

  @override
  String get relaxedModeDescription => 'خذ وقتك وركز على التعلم.';

  @override
  String get timedMode => 'مؤقت';

  @override
  String timedModeDescription(int seconds) {
    return 'لديك $seconds ثانية لكل سؤال.';
  }

  @override
  String get beginQuiz => 'ابدأ الاختبار';

  @override
  String secondsRemaining(int seconds) {
    return 'متبقٍ $seconds ث';
  }

  @override
  String get timeExpired => 'انتهى الوقت';

  @override
  String get saveAndExit => 'حفظ وخروج';

  @override
  String get abandonQuiz => 'التخلي عن الاختبار';

  @override
  String get quitQuizMessageSaved =>
      'احفظ تقدمك للمتابعة لاحقًا أو تخلّ عن هذه المحاولة.';

  @override
  String get bookmarkQuestion => 'حفظ السؤال';

  @override
  String get removeBookmark => 'إزالة من المحفوظات';

  @override
  String get progress => 'التقدم';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get attempts => 'المحاولات';

  @override
  String get accuracy => 'الدقة';

  @override
  String get correctAnswersStat => 'الإجابات الصحيحة';

  @override
  String get dailyStreak => 'السلسلة اليومية';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get categoryPerformance => 'الأداء حسب التصنيف';

  @override
  String get noHistory => 'أكمل اختبارك الأول لعرض تقدمك هنا.';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get unlocked => 'مفتوح';

  @override
  String get locked => 'مقفل';

  @override
  String get achievementFirstQuiz => 'الخطوة الأولى';

  @override
  String get achievementFirstQuizDescription => 'أكمل اختبارك الأول.';

  @override
  String get achievementPerfectScore => 'نتيجة كاملة';

  @override
  String get achievementPerfectScoreDescription =>
      'أنهِ اختبارًا بكل الإجابات الصحيحة.';

  @override
  String get achievementFiveQuizzes => 'بناء الزخم';

  @override
  String get achievementFiveQuizzesDescription => 'أكمل خمسة اختبارات.';

  @override
  String get achievementCategoryExplorer => 'مستكشف التصنيفات';

  @override
  String get achievementCategoryExplorerDescription =>
      'أجب عن أسئلة من التصنيفات الثلاثة.';

  @override
  String get achievementThreeDayStreak => 'سلسلة ثلاثة أيام';

  @override
  String get achievementThreeDayStreakDescription =>
      'أكمل اختبار اليوم لثلاثة أيام متتالية.';

  @override
  String get categoryQuiz => 'اختبار تصنيف';

  @override
  String get incorrectPractice => 'تدريب الأخطاء';

  @override
  String get bookmarkPractice => 'تدريب المحفوظات';

  @override
  String get dailyReminder => 'التذكير اليومي';

  @override
  String get dailyReminderDescription =>
      'استلم تذكيرًا محليًا لإكمال اختبار اليوم.';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get notificationsUnavailable =>
      'تتوفر التذكيرات المجدولة في تطبيقات Android وiOS وmacOS.';

  @override
  String get notificationPermissionDenied => 'لم يتم منح إذن الإشعارات.';

  @override
  String get dailyReminderTitle => 'اختبارك اليومي في كويزل جاهز';

  @override
  String get dailyReminderBody => 'حافظ على سلسلتك بخمسة أسئلة سريعة.';

  @override
  String bestScorePercent(int percent) {
    return 'الأفضل: $percent%';
  }

  @override
  String scorePercent(int percent) {
    return '$percent%';
  }
}
