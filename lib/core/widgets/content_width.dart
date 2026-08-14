import 'package:flutter/material.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({
    required this.child,
    this.maxWidth = 760,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
