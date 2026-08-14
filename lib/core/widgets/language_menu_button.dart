import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_controller.dart';
import '../../features/settings/domain/app_settings.dart';
import '../../l10n/app_localizations.dart';

class LanguageMenuButton extends ConsumerWidget {
  const LanguageMenuButton({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(settingsControllerProvider).locale;

    return PopupMenuButton<AppLocalePreference>(
      tooltip: l10n.language,
      initialValue: selected,
      onSelected: ref.read(settingsControllerProvider.notifier).setLocale,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppLocalePreference.english,
          child: Text(l10n.english),
        ),
        PopupMenuItem(
          value: AppLocalePreference.arabic,
          child: Text(l10n.arabic),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 20),
            if (!compact) ...[
              const SizedBox(width: 6),
              Text(
                Localizations.localeOf(context).languageCode.toUpperCase(),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
