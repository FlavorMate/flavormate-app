import 'package:flutter/material.dart';

class FConstrainedBoxSliver extends StatelessWidget {
  final double maxWidth;
  final Widget sliver;

  const FConstrainedBoxSliver({
    super.key,
    required this.maxWidth,
    required this.sliver,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.crossAxisExtent > maxWidth;
        final padding = isWide
            ? (constraints.crossAxisExtent - maxWidth) / 2
            : 0.0;

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: sliver,
        );
      },
    );
  }
}
