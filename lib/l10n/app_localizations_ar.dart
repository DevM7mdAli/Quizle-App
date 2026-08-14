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
  String scorePercent(int percent) {
    return '$percent%';
  }
}
