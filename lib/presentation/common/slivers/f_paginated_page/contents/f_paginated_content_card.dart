import 'dart:math';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FPaginatedContentCard<T> extends StatelessWidget {
  final List<T> data;
  final Widget Function(T) itemBuilder;

  const FPaginatedContentCard({super.key,required this.data, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .symmetric(horizontal: PADDING),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final resolution = constraints.crossAxisExtent;

          final int count = (resolution / 355).floor();

          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: max(1, count),
              mainAxisSpacing: PADDING,
              crossAxisSpacing: PADDING,
              childAspectRatio: 16 / 9,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return itemBuilder.call(item);
            },
          );
        },
      ),
    );
  }
}
