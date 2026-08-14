import 'package:flutter/material.dart';

class QuizArtwork extends StatelessWidget {
  const QuizArtwork({
    required this.categoryId,
    required this.semanticLabel,
    this.imageAsset,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String categoryId;
  final String semanticLabel;
  final String? imageAsset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final asset = imageAsset;
    if (asset != null) {
      return Image.asset(
        asset,
        fit: fit,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.tertiaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            _iconForCategory(categoryId),
            size: 58,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  IconData _iconForCategory(String id) {
    if (id.contains('film')) return Icons.movie_creation_rounded;
    if (id.contains('game')) return Icons.sports_esports_rounded;
    if (id.contains('computer') || id.contains('technology')) {
      return Icons.computer_rounded;
    }
    if (id.contains('science')) return Icons.science_rounded;
    if (id.contains('sport')) return Icons.sports_soccer_rounded;
    if (id.contains('geography')) return Icons.public_rounded;
    if (id.contains('history')) return Icons.account_balance_rounded;
    if (id.contains('programming')) return Icons.code_rounded;
    if (id.contains('safety')) return Icons.security_rounded;
    return Icons.psychology_alt_rounded;
  }
}
