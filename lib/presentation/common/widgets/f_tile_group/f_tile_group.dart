import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';

/// An M3 expressive inspired group of [ListTile]s
class FTileGroup extends StatelessWidget {
  final String? title;

  final double borderRadius;

  final List<FTile> items;

  final Color? iconBackgroundColor;

  const FTileGroup({
    super.key,
    this.title,
    required this.items,
    this.borderRadius = 16,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 2,
      children: [
        if (title != null) ...[
          FText(
            title!,
            style: .bodyMedium,
            weight: .w500,
            color: .primary,
          ),
          const SizedBox(height: 4),
        ],
        ...List.generate(items.length, (index) {
          final item = items[index];

          final topLeft = index == 0 ? borderRadius : 4.0;
          final topRight = index == 0 ? borderRadius : 4.0;
          final bottomLeft = index == items.length - 1 ? borderRadius : 4.0;
          final bottomRight = index == items.length - 1 ? borderRadius : 4.0;
          return ClipRRect(
            borderRadius: .only(
              topLeft: .circular(topLeft),
              topRight: .circular(topRight),
              bottomLeft: .circular(bottomLeft),
              bottomRight: .circular(bottomRight),
            ),
            child: Material(
              color: context.colorScheme.surfaceContainer,
              child: ListTile(
                visualDensity: .standard,
                onTap: item.onTap,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      iconBackgroundColor ??
                      context.colorScheme.primaryContainer,
                  child: Icon(
                    item.icon,
                    size: 24,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
                trailing: item.trailing,
                title: FText(
                  item.label,
                  style: .bodyLarge,
                  weight: .w600,
                ),
                subtitle: item.subLabel?.let(
                  (it) => FText(
                    it,
                    style: .bodyMedium,
                    color: .grey,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
