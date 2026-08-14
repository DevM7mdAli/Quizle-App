import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/learning_models.dart';

abstract interface class LearningRepository {
  Future<LearningData> load();

  Future<void> saveAttempts(List<QuizAttempt> attempts);

  Future<void> saveBookmarks(Set<String> questionIds);

  Future<void> saveSession(SavedQuizSession? session);
}

class SharedPreferencesLearningRepository implements LearningRepository {
  SharedPreferencesLearningRepository(this._preferences);

  static const _attemptsKey = 'learning.attempts.v1';
  static const _bookmarksKey = 'learning.bookmarks.v1';
  static const _sessionKey = 'learning.session.v1';

  final SharedPreferencesAsync _preferences;
  Future<void> _writeQueue = Future.value();

  @override
  Future<LearningData> load() async {
    final attemptsSource = await _preferences.getString(_attemptsKey);
    final bookmarks = await _preferences.getStringList(_bookmarksKey);
    final sessionSource = await _preferences.getString(_sessionKey);

    return LearningData(
      attempts: _decodeAttempts(attemptsSource),
      bookmarkedQuestionIds: Set.unmodifiable(bookmarks ?? const []),
      savedSession: _decodeSession(sessionSource),
    );
  }

  @override
  Future<void> saveAttempts(List<QuizAttempt> attempts) {
    final source = jsonEncode(
      attempts.map((attempt) => attempt.toJson()).toList(),
    );
    return _enqueue(() => _preferences.setString(_attemptsKey, source));
  }

  @override
  Future<void> saveBookmarks(Set<String> questionIds) {
    final orderedIds = questionIds.toList()..sort();
    return _enqueue(
      () => _preferences.setStringList(_bookmarksKey, orderedIds),
    );
  }

  @override
  Future<void> saveSession(SavedQuizSession? session) {
    return _enqueue(() {
      if (session == null) {
        return _preferences.remove(_sessionKey);
      }
      return _preferences.setString(_sessionKey, jsonEncode(session.toJson()));
    });
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    _writeQueue = _writeQueue.then(
      (_) => operation(),
      onError: (Object _, StackTrace __) => operation(),
    );
    return _writeQueue;
  }

  List<QuizAttempt> _decodeAttempts(String? source) {
    if (source == null) {
      return const [];
    }
    try {
      final decoded = jsonDecode(source);
      if (decoded is! List<Object?>) {
        return const [];
      }
      return decoded
          .map(
            (value) => QuizAttempt.fromJson(
              (value as Map<Object?, Object?>).cast<String, Object?>(),
            ),
          )
          .toList(growable: false);
    } on Object {
      return const [];
    }
  }

  SavedQuizSession? _decodeSession(String? source) {
    if (source == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<Object?, Object?>) {
        return null;
      }
      return SavedQuizSession.fromJson(decoded.cast<String, Object?>());
    } on Object {
      return null;
    }
  }
}
