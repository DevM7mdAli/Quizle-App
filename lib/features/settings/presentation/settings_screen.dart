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
                const SizedBox(height: 32),
                _SectionHeader(
                  title: l10n.dailyReminder,
                  description: l10n.dailyReminderDescription,
                ),
                const SizedBox(height: 14),
                if (!ref
                    .watch(notificationServiceProvider)
                    .supportsScheduledReminders)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notifications_off_outlined),
                          const SizedBox(width: 14),
                          Expanded(child: Text(l10n.notificationsUnavailable)),
                        ],
                      ),
                    ),
                  )
                else
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          title: Text(l10n.dailyReminder),
                          subtitle: Text(l10n.dailyReminderDescription),
                          value: settings.dailyReminderEnabled,
                          onChanged: (enabled) async {
                            final updated = await controller.setReminderEnabled(
                              enabled,
                            );
                            if (!updated && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.notificationPermissionDenied,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        if (settings.dailyReminderEnabled) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.schedule_rounded),
                            title: Text(l10n.reminderTime),
                            trailing: Text(
                              TimeOfDay(
                                hour: settings.reminderHour,
                                minute: settings.reminderMinute,
                              ).format(context),
                            ),
                            onTap: () async {
                              final selected = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: settings.reminderHour,
                                  minute: settings.reminderMinute,
                                ),
                              );
                              if (selected != null) {
                                await controller.setReminderTime(selected);
                              }
                            },
                          ),
                        ],
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
