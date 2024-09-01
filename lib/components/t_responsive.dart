import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TResponsive extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const TResponsive({
    required this.child,
    this.maxWidth = Breakpoints.sm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(PADDING),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
