import 'package:flutter/material.dart';

class FConstrainedBoxSliver extends StatelessWidget {
  final double maxWidth;
  final Widget sliver;
  final EdgeInsets padding;

  const FConstrainedBoxSliver({
    super.key,
    required this.maxWidth,
    required this.sliver,
    this.padding = .zero,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.crossAxisExtent > maxWidth;
        final responsivePadding = isWide
            ? (constraints.crossAxisExtent - maxWidth) / 2
            : 0.0;

        return SliverPadding(
          padding: EdgeInsets.only(
            left: responsivePadding + padding.left,
            right: responsivePadding + padding.right,
            top: padding.top,
            bottom: padding.bottom,
          ),
          sliver: sliver,
        );
      },
    );
  }
}
