import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/storage/preferences_repository.dart';
import 'features/settings/application/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesRepository = SharedPreferencesRepository(
    SharedPreferencesAsync(),
  );
  final initialSettings = await preferencesRepository.loadSettings();

  runApp(
    ProviderScope(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(preferencesRepository),
        initialSettingsProvider.overrideWithValue(initialSettings),
      ],
      child: const QuizleApp(),
    ),
  );
}
