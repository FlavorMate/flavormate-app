import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FResponsive extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const FResponsive({
    required this.child,
    this.maxWidth = FBreakpoint.smValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FFixedResponsive(maxWidth: maxWidth, child: child),
    );
  }
}

class FFixedResponsive extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const FFixedResponsive({
    required this.child,
    this.maxWidth = FBreakpoint.smValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(PADDING),
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
