import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quiz_repository.dart';
import '../domain/quiz_models.dart';

final quizRepositoryProvider = Provider<QuizRepository>(
  (ref) => AssetQuizRepository(rootBundle),
);

final quizCatalogProvider = FutureProvider.family<List<Quiz>, String>((
  ref,
  languageCode,
) {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.loadCatalog(Locale(languageCode));
});
