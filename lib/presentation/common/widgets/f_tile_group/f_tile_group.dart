import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

/// An M3 expressive inspired group of [ListTile]s
class FTileGroup extends StatelessWidget {
  final String? title;
  final String? subTitle;

  final Color? backgroundColor;

  final List<FTile> items;

  const FTileGroup({
    super.key,
    this.title,
    this.subTitle,
    this.backgroundColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).listTheme.cardList;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: theme.gap,
      children: [
        if (title != null) ...[
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              FText(
                title!,
                style: .bodyMedium,
                fontWeight: .w500,
                color: .primary,
              ),
              if (subTitle != null)
                FText(
                  subTitle!,
                  style: .bodyMedium,
                  color: .grey,
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ...List.generate(items.length, (index) {
          final item = items[index];

          final first = index == 0;
          final last = index == items.length - 1;

          return buildTile(
            context: context,
            first: first,
            last: last,
            backgroundColor: backgroundColor,
            item: item,
          );
        }),
      ],
    );
  }

  static M3ECard buildTile({
    required BuildContext context,
    required bool first,
    required bool last,
    required Color? backgroundColor,
    required FTile item,
    bool disabled = false,
  }) {
    final theme = M3ETheme.of(context).listTheme.cardList;
    final single = first && last;

    final M3ECardPosition position = single
        ? .single
        : first
        ? .first
        : last
        ? .last
        : .middle;

    final borderRadius = calculateCardRadius(
      position: position,
      outerRadius: theme.outerRadius,
      innerRadius: theme.innerRadius,
    );

    return M3ECard(
      variant: .filled,
      color: disabled
          ? context.colorScheme.surfaceContainerHighest
          : backgroundColor ?? context.colorScheme.surfaceContainer,
      borderRadius: borderRadius,
      onPressed: disabled ? null : item.onTap,
      padding: const .symmetric(
        horizontal: PADDING,
        vertical: PADDING,
      ),
      child: item,
    );
  }
}
