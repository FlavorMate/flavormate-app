import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';

/// An M3 expressive inspired group of [ListTile]s
class FTileGroup extends StatelessWidget {
  final String? title;

  final double borderRadius;

  final List<FTile> items;

  const FTileGroup({
    super.key,
    this.title,
    required this.items,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 2,
      children: [
        if (title != null) ...[
          FText(title!, style: .bodyMedium),
          const SizedBox(height: 4),
        ],
        ...List.generate(items.length, (index) {
          final item = items[index];

          final topLeft = index == 0 ? borderRadius : 0.0;
          final topRight = index == 0 ? borderRadius : 0.0;
          final bottomLeft = index == items.length - 1 ? borderRadius : 0.0;
          final bottomRight = index == items.length - 1 ? borderRadius : 0.0;
          return ListTile(
            visualDensity: .standard,
            shape: RoundedRectangleBorder(
              borderRadius: .only(
                topLeft: .circular(topLeft),
                topRight: .circular(topRight),
                bottomLeft: .circular(bottomLeft),
                bottomRight: .circular(bottomRight),
              ),
            ),
            dense: true,
            onTap: item.onTap,
            tileColor: context.colorScheme.surfaceContainer,
            leading: Icon(item.icon),
            title: Text(item.label),
          );
        }),
      ],
    );
  }
}
