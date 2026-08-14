import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ContentWidth(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionHeader(
                  title: l10n.language,
                  description: l10n.languageDescription,
                ),
                const SizedBox(height: 14),
                Card(
                  child: Column(
                    children: [
                      _SelectionTile<AppLocalePreference>(
                        title: l10n.followSystem,
                        value: AppLocalePreference.system,
                        groupValue: settings.locale,
                        onSelected: controller.setLocale,
                      ),
                      const Divider(height: 1),
                      _SelectionTile<AppLocalePreference>(
                        title: l10n.english,
                        value: AppLocalePreference.english,
                        groupValue: settings.locale,
                        onSelected: controller.setLocale,
                      ),
                      const Divider(height: 1),
                      _SelectionTile<AppLocalePreference>(
                        title: l10n.arabic,
                        value: AppLocalePreference.arabic,
                        groupValue: settings.locale,
                        onSelected: controller.setLocale,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _SectionHeader(
                  title: l10n.appearance,
                  description: l10n.appearanceDescription,
                ),
                const SizedBox(height: 14),
                Card(
                  child: Column(
                    children: [
                      _SelectionTile<ThemeMode>(
                        title: l10n.systemTheme,
                        value: ThemeMode.system,
                        groupValue: settings.themeMode,
                        onSelected: controller.setThemeMode,
                      ),
                      const Divider(height: 1),
                      _SelectionTile<ThemeMode>(
                        title: l10n.lightTheme,
                        value: ThemeMode.light,
                        groupValue: settings.themeMode,
                        onSelected: controller.setThemeMode,
                      ),
                      const Divider(height: 1),
                      _SelectionTile<ThemeMode>(
                        title: l10n.darkTheme,
                        value: ThemeMode.dark,
                        groupValue: settings.themeMode,
                        onSelected: controller.setThemeMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SelectionTile<T> extends StatelessWidget {
  const _SelectionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: () => onSelected(value),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 16, 18, 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
