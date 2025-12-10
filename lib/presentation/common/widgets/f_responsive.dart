import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FResponsive extends StatelessWidget {
  final ScrollBehavior? scrollBehavior;
  final double maxWidth;
  final Widget child;

  const FResponsive({
    super.key,
    this.maxWidth = FBreakpoint.smValue,
    this.scrollBehavior,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: scrollBehavior ?? ScrollConfiguration.of(context),
      child: SingleChildScrollView(
        child: FFixedResponsive(maxWidth: maxWidth, child: child),
      ),
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
