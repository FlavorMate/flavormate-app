import 'package:flavormate/core/constants/color_constants.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class SettingsAppThemeTileList extends StatelessWidget {
  final String title;
  final List<SettingsAppThemeTileData> values;

  const SettingsAppThemeTileList({
    super.key,
    required this.title,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).listTheme.cardList;

    return Column(
      spacing: theme.gap,
      crossAxisAlignment: .start,
      children: [
        FText(
          title,
          style: .bodyMedium,
          fontWeight: .w500,
          color: .primary,
        ),
        ....generate(
          values.length,
          (index) {
            final first = index == 0;
            final last = index == values.length - 1;

            final value = values[index];

            final foregroundColor = switch (calcColorForText(value.color)) {
              Colors.white => FTextColor.white,
              Colors.black => FTextColor.black,
              _ => throw UnimplementedError(),
            };

            return FTile.manual(
              context: context,
              first: first,
              last: last,
              backgroundColor: value.color,

              tile: FTile(
                foregroundColor: foregroundColor,
                leading: Icon(
                  value.isSelected
                      ? Symbols.check_circle_rounded
                      : Symbols.circle_rounded,
                  color: foregroundColor.getThemeColor(context),
                ),
                label: value.label,
                onTap: () => value.onTap(value.color),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SettingsAppThemeTileData {
  final bool isSelected;
  final Color color;
  final String label;
  final void Function(Color) onTap;

  const SettingsAppThemeTileData({
    required this.isSelected,
    required this.color,
    required this.label,
    required this.onTap,
  });
}
