import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_paths.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/language_menu_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isCompleting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _pages(l10n);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _OnboardingHeader(onSkip: _isCompleting ? null : _complete),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) => _OnboardingPage(
                  page: pages[index],
                  currentPage: _currentPage,
                  pageCount: pages.length,
                  isCompleting: _isCompleting,
                  onBack: index == 0 ? null : _previous,
                  onContinue: index == pages.length - 1 ? _complete : _next,
                  onSkip: _complete,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_OnboardingPageData> _pages(AppLocalizations l10n) => [
    _OnboardingPageData(
      eyebrow: l10n.onboardingDiscoverEyebrow,
      title: l10n.onboardingDiscoverTitle,
      description: l10n.onboardingDiscoverDescription,
      icon: Icons.travel_explore_rounded,
      accent: const Color(0xFF6E5AE6),
      highlights: [
        l10n.onboardingLiveCategories,
        l10n.onboardingBilingual,
        l10n.onboardingOfflineReady,
      ],
    ),
    _OnboardingPageData(
      eyebrow: l10n.onboardingPersonalizeEyebrow,
      title: l10n.onboardingPersonalizeTitle,
      description: l10n.onboardingPersonalizeDescription,
      icon: Icons.tune_rounded,
      accent: const Color(0xFF167C80),
      highlights: [
        l10n.onboardingChooseLevel,
        l10n.onboardingPickLength,
        l10n.onboardingSetPace,
      ],
    ),
    _OnboardingPageData(
      eyebrow: l10n.onboardingProgressEyebrow,
      title: l10n.onboardingProgressTitle,
      description: l10n.onboardingProgressDescription,
      icon: Icons.insights_rounded,
      accent: const Color(0xFFE0713B),
      highlights: [
        l10n.onboardingSavedQuestions,
        l10n.onboardingMistakePractice,
        l10n.onboardingDailyStreaks,
      ],
    ),
  ];

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _previous() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _complete() async {
    setState(() => _isCompleting = true);
    try {
      await ref.read(onboardingControllerProvider.notifier).complete();
      if (mounted) {
        context.go(AppPaths.home);
      }
    } on Object {
      if (!mounted) {
        return;
      }
      setState(() => _isCompleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).saveFailure)),
      );
    }
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({required this.onSkip});

  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;
          return Row(
            children: [
              AppLogo(size: 38, semanticLabel: l10n.appName),
              if (!compact) ...[
                const SizedBox(width: 10),
                Text(
                  l10n.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
              const Spacer(),
              LanguageMenuButton(compact: compact),
              const SizedBox(width: 4),
              if (kIsWeb)
                IconButton(
                  tooltip: l10n.backToWebsite,
                  onPressed: () => context.go(AppPaths.landing),
                  icon: const Icon(Icons.close_rounded),
                )
              else if (compact)
                IconButton(
                  tooltip: l10n.skip,
                  onPressed: onSkip,
                  icon: const Icon(Icons.skip_next_rounded),
                )
              else
                TextButton(onPressed: onSkip, child: Text(l10n.skip)),
            ],
          );
        },
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.page,
    required this.currentPage,
    required this.pageCount,
    required this.isCompleting,
    required this.onBack,
    required this.onContinue,
    required this.onSkip,
  });

  final _OnboardingPageData page;
  final int currentPage;
  final int pageCount;
  final bool isCompleting;
  final VoidCallback? onBack;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 860;
        final content = _OnboardingCopy(
          page: page,
          currentPage: currentPage,
          pageCount: pageCount,
          isCompleting: isCompleting,
          onBack: onBack,
          onContinue: onContinue,
          onSkip: onSkip,
        );
        final visual = _OnboardingVisual(page: page);

        return SingleChildScrollView(
          padding: EdgeInsetsDirectional.fromSTEB(
            wide ? 48 : 20,
            wide ? 24 : 12,
            wide ? 48 : 20,
            28,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: wide
                  ? Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: SizedBox(height: 620, child: visual),
                        ),
                        const SizedBox(width: 64),
                        Expanded(flex: 9, child: content),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 260, child: visual),
                        const SizedBox(height: 30),
                        content,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({
    required this.page,
    required this.currentPage,
    required this.pageCount,
    required this.isCompleting,
    required this.onBack,
    required this.onContinue,
    required this.onSkip,
  });

  final _OnboardingPageData page;
  final int currentPage;
  final int pageCount;
  final bool isCompleting;
  final VoidCallback? onBack;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isLast = currentPage == pageCount - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          page.eyebrow,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: page.accent,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(
            page.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 42,
              letterSpacing: -1.1,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          page.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final highlight in page.highlights)
              _HighlightPill(label: highlight, accent: page.accent),
          ],
        ),
        const SizedBox(height: 38),
        Row(
          children: [
            for (var index = 0; index < pageCount; index++) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: index == currentPage ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              if (index < pageCount - 1) const SizedBox(width: 7),
            ],
            const Spacer(),
            Text(
              l10n.onboardingStep(currentPage + 1, pageCount),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            if (onBack != null) ...[
              OutlinedButton(
                onPressed: isCompleting ? null : onBack,
                child: Text(l10n.back),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FilledButton.icon(
                key: const Key('onboarding-primary-action'),
                onPressed: isCompleting ? null : onContinue,
                icon: isCompleting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        isLast
                            ? Icons.arrow_forward_rounded
                            : Icons.navigate_next_rounded,
                      ),
                label: Text(isLast ? l10n.startExploring : l10n.continueLabel),
              ),
            ),
          ],
        ),
        if (kIsWeb) ...[
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.center,
            child: TextButton(
              onPressed: isCompleting ? null : onSkip,
              child: Text(isLast ? l10n.startExploring : l10n.skipTour),
            ),
          ),
        ],
      ],
    );
  }
}

class _OnboardingVisual extends StatelessWidget {
  const _OnboardingVisual({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              Color.alphaBlend(
                page.accent.withValues(alpha: 0.22),
                colorScheme.surfaceContainer,
              ),
              Color.alphaBlend(
                page.accent.withValues(alpha: 0.06),
                colorScheme.surfaceContainerLowest,
              ),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PositionedDirectional(
              top: -80,
              end: -40,
              child: _SoftCircle(size: 230, color: page.accent),
            ),
            PositionedDirectional(
              bottom: -95,
              start: -70,
              child: _SoftCircle(size: 260, color: page.accent),
            ),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: page.accent.withValues(alpha: 0.16),
                      blurRadius: 40,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(34),
                  child: Icon(page.icon, size: 92, color: page.accent),
                ),
              ),
            ),
            PositionedDirectional(
              start: 24,
              top: 30,
              child: _FloatingMetric(
                icon: Icons.bolt_rounded,
                label: page.highlights.first,
                accent: page.accent,
              ),
            ),
            PositionedDirectional(
              end: 24,
              bottom: 32,
              child: _FloatingMetric(
                icon: Icons.check_circle_rounded,
                label: page.highlights.last,
                accent: page.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.09),
      ),
    );
  }
}

class _FloatingMetric extends StatelessWidget {
  const _FloatingMetric({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 14, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 19, color: accent),
            const SizedBox(width: 7),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _HighlightPill extends StatelessWidget {
  const _HighlightPill({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: accent,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.highlights,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final List<String> highlights;
}
