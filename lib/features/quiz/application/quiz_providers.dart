import 'dart:ui';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/open_trivia_db_client.dart';
import '../data/open_trivia_quiz_repository.dart';
import '../data/quiz_repository.dart';
import '../domain/quiz_models.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return HybridQuizRepository(
    assets: AssetQuizRepository(rootBundle),
    remote: OpenTriviaQuizRepository(
      client: OpenTriviaDbClient(ref.watch(httpClientProvider)),
      cache: CachedQuery.instance,
    ),
  );
});

final quizCatalogProvider = FutureProvider.family<List<Quiz>, String>((
  ref,
  languageCode,
) {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.loadCatalog(Locale(languageCode));
});
