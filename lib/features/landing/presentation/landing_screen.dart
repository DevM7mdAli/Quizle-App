import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_paths.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/language_menu_button.dart';
import '../../../l10n/app_localizations.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  final GlobalKey _featuresKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _LandingHeader(onOpenApp: _openApp)),
            SliverToBoxAdapter(
              child: _LandingSection(
                top: 72,
                bottom: 86,
                child: _Hero(
                  onPrimaryAction: _openApp,
                  onSecondaryAction: _showFeatures,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _ProofStrip()),
            SliverToBoxAdapter(
              child: _LandingSection(
                key: _featuresKey,
                top: 96,
                bottom: 96,
                child: const _FeatureSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: ColoredBox(
                color: colorScheme.surfaceContainerLowest,
                child: const _LandingSection(
                  top: 96,
                  bottom: 96,
                  child: _PlatformSection(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _LandingSection(
                top: 88,
                bottom: 72,
                child: _ClosingCallToAction(onPressed: _openApp),
              ),
            ),
            SliverToBoxAdapter(child: _Footer(onOpenApp: _openApp)),
          ],
        ),
      ),
    );
  }

  void _openApp() => context.go(AppPaths.webApp);

  void _showFeatures() {
    final featureContext = _featuresKey.currentContext;
    if (featureContext == null) {
      return;
    }
    Scrollable.ensureVisible(
      featureContext,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }
}

class _LandingHeader extends StatelessWidget {
  const _LandingHeader({required this.onOpenApp});

  final VoidCallback onOpenApp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 520;
              return Row(
                children: [
                  _Brand(name: l10n.appName, compact: compact),
                  const Spacer(),
                  LanguageMenuButton(compact: compact),
                  const SizedBox(width: 8),
                  if (compact)
                    IconButton.filled(
                      key: const Key('landing-primary-action'),
                      tooltip: l10n.openQuizle,
                      onPressed: onOpenApp,
                      icon: const Icon(Icons.arrow_forward_rounded),
                    )
                  else
                    FilledButton(
                      key: const Key('landing-primary-action'),
                      onPressed: onOpenApp,
                      child: Text(l10n.openQuizle),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.name, this.compact = false});

  final String name;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: 38, semanticLabel: name),
        if (!compact) ...[
          const SizedBox(width: 10),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
        ],
      ],
    );
  }
}

class _LandingSection extends StatelessWidget {
  const _LandingSection({
    required this.child,
    required this.top,
    required this.bottom,
    super.key,
  });

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24, top, 24, bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onPrimaryAction, required this.onSecondaryAction});

  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 940;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Eyebrow(label: l10n.landingHeroEyebrow),
            const SizedBox(height: 20),
            Semantics(
              header: true,
              child: Text(
                l10n.landingHeroTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: wide ? 58 : 42,
                  height: 1.04,
                  letterSpacing: -1.8,
                ),
              ),
            ),
            const SizedBox(height: 22),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 590),
              child: Text(
                l10n.landingHeroDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: onPrimaryAction,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.startLearning),
                ),
                OutlinedButton(
                  onPressed: onSecondaryAction,
                  child: Text(l10n.seeHowItWorks),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 18,
              runSpacing: 10,
              children: [
                _TrustItem(label: l10n.noAccountRequired),
                _TrustItem(label: l10n.arabicAndEnglish),
                _TrustItem(label: l10n.offlineReady),
              ],
            ),
          ],
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              copy,
              const SizedBox(height: 52),
              const _ProductPreview(),
            ],
          );
        }
        return Row(
          children: [
            Expanded(flex: 10, child: copy),
            const SizedBox(width: 62),
            const Expanded(flex: 9, child: _ProductPreview()),
          ],
        );
      },
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: context.quizColors.success,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

class _ProductPreview extends StatelessWidget {
  const _ProductPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final quizColors = context.quizColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [quizColors.heroStart, quizColors.heroEnd],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: quizColors.heroEnd.withValues(alpha: 0.24),
            blurRadius: 52,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE86A65),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5B84B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF54B87B),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.appName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  l10n.landingPreviewGreeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.landingPreviewDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const SizedBox.square(
                            dimension: 48,
                            child: Icon(
                              Icons.today_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dailyQuiz,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                l10n.dailyQuizDescription,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _PreviewMetric(
                        icon: Icons.local_fire_department_rounded,
                        value: '7',
                        label: l10n.landingDayStreak,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PreviewMetric(
                        icon: Icons.track_changes_rounded,
                        value: '86%',
                        label: l10n.accuracy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 21, color: colorScheme.primary),
            const SizedBox(height: 10),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProofStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 42,
            runSpacing: 22,
            children: [
              _ProofItem(value: '4,000+', label: l10n.freshQuestions),
              _ProofItem(value: '8', label: l10n.liveCategories),
              _ProofItem(value: '2', label: l10n.interfaceLanguages),
              _ProofItem(value: '0', label: l10n.requiredAccounts),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProofItem extends StatelessWidget {
  const _ProofItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 9),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = [
      _FeatureData(
        icon: Icons.auto_awesome_rounded,
        title: l10n.landingFreshTitle,
        description: l10n.landingFreshDescription,
      ),
      _FeatureData(
        icon: Icons.tune_rounded,
        title: l10n.landingFlexibleTitle,
        description: l10n.landingFlexibleDescription,
      ),
      _FeatureData(
        icon: Icons.bookmark_added_rounded,
        title: l10n.landingPracticeTitle,
        description: l10n.landingPracticeDescription,
      ),
      _FeatureData(
        icon: Icons.insights_rounded,
        title: l10n.landingProgressTitle,
        description: l10n.landingProgressDescription,
      ),
    ];

    return Column(
      children: [
        _Eyebrow(label: l10n.landingFeaturesEyebrow),
        const SizedBox(height: 18),
        Semantics(
          header: true,
          child: Text(
            l10n.landingFeaturesTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 38,
              letterSpacing: -0.8,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            l10n.landingFeaturesDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 42),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 820 ? 2 : 1;
            const gap = 16.0;
            final width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - gap) / 2;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final feature in features)
                  SizedBox(
                    width: width,
                    child: _FeatureCard(data: feature),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data});

  final _FeatureData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox.square(
                dimension: 52,
                child: Icon(data.icon, color: colorScheme.primary),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformSection extends StatelessWidget {
  const _PlatformSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final platforms = [
      _PlatformData(
        icon: Icons.language_rounded,
        title: l10n.webPlatform,
        description: l10n.webPlatformDescription,
      ),
      _PlatformData(
        icon: Icons.phone_iphone_rounded,
        title: l10n.mobilePlatform,
        description: l10n.mobilePlatformDescription,
      ),
      _PlatformData(
        icon: Icons.desktop_windows_rounded,
        title: l10n.desktopPlatform,
        description: l10n.desktopPlatformDescription,
      ),
    ];

    return Column(
      children: [
        _Eyebrow(label: l10n.landingPlatformsEyebrow),
        const SizedBox(height: 18),
        Semantics(
          header: true,
          child: Text(
            l10n.landingPlatformsTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 38,
              letterSpacing: -0.8,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            l10n.landingPlatformsDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 42),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900 ? 3 : 1;
            const gap = 16.0;
            final width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - gap * 2) / 3;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final platform in platforms)
                  SizedBox(
                    width: width,
                    child: _PlatformCard(platform: platform),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PlatformCard extends StatelessWidget {
  const _PlatformCard({required this.platform});

  final _PlatformData platform;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(platform.icon, size: 34, color: colorScheme.primary),
          const SizedBox(height: 18),
          Text(platform.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            platform.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClosingCallToAction extends StatelessWidget {
  const _ClosingCallToAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quizColors = context.quizColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [quizColors.heroStart, quizColors.heroEnd],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
        child: Column(
          children: [
            Text(
              l10n.landingCtaTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                l10n.landingCtaDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: quizColors.heroStart,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(l10n.openQuizle),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onOpenApp});

  final VoidCallback onOpenApp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 420;
                return Flex(
                  direction: compact ? Axis.vertical : Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: compact
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    if (compact)
                      _Brand(name: l10n.appName)
                    else
                      Expanded(child: _Brand(name: l10n.appName)),
                    if (compact) const SizedBox(height: 12),
                    TextButton(
                      onPressed: onOpenApp,
                      child: Text(l10n.openQuizle),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _PlatformData {
  const _PlatformData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
