import 'dart:ui';

import 'package:flutter/services.dart';

import '../domain/quiz_models.dart';

abstract interface class QuizRepository {
  Future<List<Quiz>> loadCatalog(Locale locale);
}

class AssetQuizRepository implements QuizRepository {
  const AssetQuizRepository(this.assetBundle);

  final AssetBundle assetBundle;

  @override
  Future<List<Quiz>> loadCatalog(Locale locale) async {
    final languageCode = locale.languageCode == 'ar' ? 'ar' : 'en';
    final source = await assetBundle.loadString(
      'assets/content/quizzes_$languageCode.json',
    );
    return QuizCatalog.fromJsonString(source).quizzes;
  }
}
