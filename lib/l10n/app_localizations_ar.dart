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
  String get liveTrivia => 'أسئلة مباشرة';

  @override
  String get offlineQuizzes => 'اختبارات دون اتصال';

  @override
  String get onlineQuestions => 'أسئلة جديدة عبر الإنترنت';

  @override
  String get openTriviaAttribution =>
      'الأسئلة من Open Trivia DB · ترخيص CC BY-SA 4.0';

  @override
  String get viewLicense => 'عرض الترخيص';

  @override
  String get loadingQuestions => 'جارٍ البحث عن أسئلة جديدة…';

  @override
  String get questionLoadFailure =>
      'الأسئلة الجديدة غير متاحة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get noMatchingQuestions =>
      'لا توجد أسئلة كافية لهذا الاختيار. جرّب مستوى أو عددًا آخر.';

  @override
  String get dailyOfflineFallback =>
      'الأسئلة المباشرة غير متاحة، لذا يستخدم اختبار اليوم الأسئلة المحفوظة.';

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
      'أجب عن أسئلة من ثلاثة تصنيفات مختلفة.';

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

  @override
  String get back => 'رجوع';

  @override
  String get skip => 'تخطي';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get skipTour => 'تخطي الجولة';

  @override
  String get startExploring => 'ابدأ الاستكشاف';

  @override
  String get backToWebsite => 'العودة إلى الموقع';

  @override
  String get saveFailure => 'تعذر حفظ تفضيلك. حاول مرة أخرى.';

  @override
  String onboardingStep(int current, int total) {
    return '$current من $total';
  }

  @override
  String get onboardingDiscoverEyebrow => 'مصمم حول فضولك';

  @override
  String get onboardingDiscoverTitle => 'الاختبار الأفضل يبدأ بسؤال أفضل';

  @override
  String get onboardingDiscoverDescription =>
      'استكشف أسئلة جديدة ضمن تصنيفات متنوعة، واستفد من اختبارات محفوظة تعمل حتى عند انقطاع الاتصال.';

  @override
  String get onboardingLiveCategories => '8 تصنيفات مباشرة';

  @override
  String get onboardingBilingual => 'العربية والإنجليزية';

  @override
  String get onboardingOfflineReady => 'جاهز دون اتصال';

  @override
  String get onboardingPersonalizeEyebrow => 'جلستك وفق اختيارك';

  @override
  String get onboardingPersonalizeTitle => 'اجعل كل جلسة مناسبة لوقتك';

  @override
  String get onboardingPersonalizeDescription =>
      'اختر الصعوبة وعدد الأسئلة والوتيرة قبل أن تبدأ. خذ وقتك أو فعّل المؤقت عندما تريد تحديًا إضافيًا.';

  @override
  String get onboardingChooseLevel => 'اختر المستوى';

  @override
  String get onboardingPickLength => 'حدد عدد الأسئلة';

  @override
  String get onboardingSetPace => 'حدد الوتيرة';

  @override
  String get onboardingProgressEyebrow => 'تقدم يمكنك الاستفادة منه';

  @override
  String get onboardingProgressTitle => 'تدرّب على المهم وتابع تطورك';

  @override
  String get onboardingProgressDescription =>
      'ارجع إلى الأسئلة الخاطئة أو المحفوظة، وحافظ على سلسلتك اليومية، واستفد من سجلك لتحديد خطوتك التالية.';

  @override
  String get onboardingSavedQuestions => 'أسئلة محفوظة';

  @override
  String get onboardingMistakePractice => 'تدريب الأخطاء';

  @override
  String get onboardingDailyStreaks => 'سلاسل يومية';

  @override
  String get openQuizle => 'افتح كويزل';

  @override
  String get startLearning => 'ابدأ التعلم';

  @override
  String get seeHowItWorks => 'اكتشف طريقة العمل';

  @override
  String get noAccountRequired => 'دون حساب';

  @override
  String get arabicAndEnglish => 'العربية والإنجليزية';

  @override
  String get offlineReady => 'يعمل دون اتصال';

  @override
  String get landingHeroEyebrow => 'تعلّم يناسب يومك';

  @override
  String get landingHeroTitle => 'حوّل دقائقك المتاحة إلى تقدم حقيقي.';

  @override
  String get landingHeroDescription =>
      'يجمع كويزل بين الأسئلة الجديدة والتدريب المركّز ومتابعة التقدم على الويب والجوال وسطح المكتب.';

  @override
  String get landingPreviewGreeting => 'هل أنت مستعد لتحدٍ سريع؟';

  @override
  String get landingPreviewDescription =>
      'خمسة أسئلة فقط تفصلك عن اختبارك التالي.';

  @override
  String get landingDayStreak => 'أيام متتالية';

  @override
  String get freshQuestions => 'سؤال متجدد';

  @override
  String get liveCategories => 'تصنيفات مباشرة';

  @override
  String get interfaceLanguages => 'لغتان للواجهة';

  @override
  String get requiredAccounts => 'حسابات مطلوبة';

  @override
  String get landingFeaturesEyebrow => 'مصمم لتقدم حقيقي';

  @override
  String get landingFeaturesTitle => 'أكثر من مجرد قائمة أسئلة';

  @override
  String get landingFeaturesDescription =>
      'يساعدك كل جزء في كويزل على البدء بسرعة والتعلم من كل إجابة والعودة بخطوة تالية واضحة.';

  @override
  String get landingFreshTitle => 'أسئلة جديدة وبديل موثوق';

  @override
  String get landingFreshDescription =>
      'استكشف الأسئلة المباشرة عند الاتصال وتابع الاختبارات المحفوظة عندما تكون دون اتصال.';

  @override
  String get landingFlexibleTitle => 'جلسة تناسب وقتك';

  @override
  String get landingFlexibleDescription =>
      'حدد الموضوع والصعوبة وعدد الأسئلة والوتيرة قبل كل اختبار.';

  @override
  String get landingPracticeTitle => 'تدرّب حيث تحتاج';

  @override
  String get landingPracticeDescription =>
      'احفظ الأسئلة المفيدة وارجع إلى الإجابات التي ما زالت تحتاج إلى تدريب.';

  @override
  String get landingProgressTitle => 'تقدم ضمن سياقه';

  @override
  String get landingProgressDescription =>
      'تابع الدقة والسجل والسلاسل والإنجازات وأداءك في كل تصنيف.';

  @override
  String get landingPlatformsEyebrow => 'تجربة واحدة على كل شاشة';

  @override
  String get landingPlatformsTitle => 'مصمم للويب والتطبيق وسطح المكتب';

  @override
  String get landingPlatformsDescription =>
      'تجربة تعلم مركّزة تتكيف بسلاسة مع الشاشة التي تستخدمها.';

  @override
  String get webPlatform => 'الويب';

  @override
  String get webPlatformDescription =>
      'افتح كويزل فورًا في متصفح حديث واحتفظ بتقدمك على جهازك.';

  @override
  String get mobilePlatform => 'تطبيق الجوال';

  @override
  String get mobilePlatformDescription =>
      'تجربة لمس مركّزة للجلسات السريعة والتدريب اليومي والتذكيرات المحلية.';

  @override
  String get desktopPlatform => 'سطح المكتب';

  @override
  String get desktopPlatformDescription =>
      'مساحة أوسع لجلسات التدريب الطويلة على macOS وWindows وLinux.';

  @override
  String get landingCtaTitle => 'سؤالك التالي بانتظارك';

  @override
  String get landingCtaDescription =>
      'ابدأ بمقدمة قصيرة، واختر تصنيفًا، واستثمر دقائقك المتاحة اليوم.';
}
