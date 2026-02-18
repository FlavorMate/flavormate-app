import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';

/// An M3 expressive inspired group of [ListTile]s
class FTileGroup extends StatelessWidget {
  final String? title;

  final List<FTile> items;

  const FTileGroup({
    super.key,
    this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: 2,
      children: [
        if (title != null) ...[
          FText(
            title!,
            style: .bodyMedium,
            fontWeight: .w500,
            color: .primary,
          ),
          const SizedBox(height: 4),
        ],
        ...List.generate(items.length, (index) {
          final item = items[index];

          final top = index == 0 ? BORDER_RADIUS_OUT : BORDER_RADIUS_IN;

          final bottom = index == items.length - 1
              ? BORDER_RADIUS_OUT
              : BORDER_RADIUS_IN;

          return ClipRRect(
            borderRadius: .only(
              topLeft: .circular(top),
              topRight: .circular(top),
              bottomLeft: .circular(bottom),
              bottomRight: .circular(bottom),
            ),
            child: item,
          );
        }),
      ],
    );
  }
}
