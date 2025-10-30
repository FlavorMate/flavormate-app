import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FPageableContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollController controller;

  const FPageableContent({
    super.key,
    required this.child,
    required this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: FPageableFixedContent(
        padding: padding,
        child: child,
      ),
    );
  }
}

class FPageableFixedContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const FPageableFixedContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(PADDING),
      child: child,
    );
  }
}
