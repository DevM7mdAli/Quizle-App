import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({required this.size, this.semanticLabel, super.key});

  static const assetPath = 'assets/branding/quizle-icon-source.png';

  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheSize = (size * pixelRatio).ceil();

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.26),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: cacheSize,
        cacheHeight: cacheSize,
        filterQuality: FilterQuality.medium,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
