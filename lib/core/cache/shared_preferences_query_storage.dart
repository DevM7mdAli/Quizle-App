import 'dart:async';
import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesQueryStorage implements StorageInterface {
  SharedPreferencesQueryStorage._(this._preferences, this._entries);

  static const _storageKey = 'cached_query.entries.v1';
  static const _maximumEntryCount = 40;

  final SharedPreferencesAsync _preferences;
  final Map<String, StoredQuery> _entries;
  Future<void> _writeQueue = Future.value();

  static Future<SharedPreferencesQueryStorage> initialize(
    SharedPreferencesAsync preferences,
  ) async {
    final entries = <String, StoredQuery>{};
    final source = await preferences.getString(_storageKey);
    if (source != null) {
      try {
        final decoded = jsonDecode(source);
        if (decoded is Map<Object?, Object?>) {
          for (final entry in decoded.entries) {
            final key = entry.key;
            final value = entry.value;
            if (key is! String || value is! Map<Object?, Object?>) {
              continue;
            }
            final stored = _decodeStoredQuery(
              key,
              value.cast<String, Object?>(),
            );
            if (stored != null && stored.isNotExpired) {
              entries[stored.key] = stored;
            }
          }
        }
      } on Object {
        entries.clear();
      }
    }
    return SharedPreferencesQueryStorage._(preferences, entries);
  }

  @override
  void close() {}

  @override
  void delete(String key) {
    if (_entries.remove(key) != null) {
      unawaited(_persist());
    }
  }

  @override
  void deleteAll() {
    _entries.clear();
    unawaited(_enqueue(() => _preferences.remove(_storageKey)));
  }

  @override
  StoredQuery? get(String key) {
    final entry = _entries[key];
    if (entry == null) {
      return null;
    }
    if (entry.isExpired) {
      delete(key);
      return null;
    }
    return entry;
  }

  @override
  void put(StoredQuery query) {
    _entries[query.key] = query;
    _trimEntries();
    unawaited(_persist());
  }

  Future<void> _persist() {
    final source = jsonEncode({
      for (final entry in _entries.entries)
        entry.key: {
          'data': entry.value.data,
          'createdAt': entry.value.createdAt.toIso8601String(),
          'storageDurationMs': entry.value.storageDuration?.inMilliseconds,
        },
    });
    return _enqueue(() => _preferences.setString(_storageKey, source));
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    _writeQueue = _writeQueue.then(
      (_) => operation(),
      onError: (Object _, StackTrace __) => operation(),
    );
    return _writeQueue;
  }

  void _trimEntries() {
    if (_entries.length <= _maximumEntryCount) {
      return;
    }
    final ordered = _entries.values.toList()
      ..sort((first, second) => first.createdAt.compareTo(second.createdAt));
    final removeCount = _entries.length - _maximumEntryCount;
    for (final entry in ordered.take(removeCount)) {
      _entries.remove(entry.key);
    }
  }

  static StoredQuery? _decodeStoredQuery(
    String key,
    Map<String, Object?> json,
  ) {
    final createdAt = json['createdAt'];
    final storageDurationMs = json['storageDurationMs'];
    if (createdAt is! String) {
      return null;
    }
    final parsedCreatedAt = DateTime.tryParse(createdAt);
    if (parsedCreatedAt == null) {
      return null;
    }
    return StoredQuery(
      key: key,
      data: json['data'],
      createdAt: parsedCreatedAt,
      storageDuration: storageDurationMs is int
          ? Duration(milliseconds: storageDurationMs)
          : null,
    );
  }
}
