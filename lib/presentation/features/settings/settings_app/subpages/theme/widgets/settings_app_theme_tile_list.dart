import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/theme/widgets/settings_app_theme_tile.dart';
import 'package:flutter/material.dart';

class SettingsAppThemeTileList extends StatelessWidget {
  final String title;
  final List<SettingsAppThemeTileData> values;

  final double borderRadius = 16;

  const SettingsAppThemeTileList({
    super.key,
    required this.title,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      crossAxisAlignment: .start,
      children: [
        FText(
          title,
          style: .bodyMedium,
          weight: .w500,
          color: .primary,
        ),
        const SizedBox(height: 4),

        ....generate(
          values.length,
          (index) {
            final value = values[index];

            final topLeft = index == 0 ? borderRadius : 4.0;
            final topRight = index == 0 ? borderRadius : 4.0;
            final bottomLeft = index == values.length - 1 ? borderRadius : 4.0;
            final bottomRight = index == values.length - 1 ? borderRadius : 4.0;

            return SettingsAppThemeTile(
              isSelected: value.isSelected,
              color: value.color,
              label: value.label,
              borderRadiusGeometry: .only(
                topLeft: .circular(topLeft),
                topRight: .circular(topRight),
                bottomLeft: .circular(bottomLeft),
                bottomRight: .circular(bottomRight),
              ),
              onTap: value.onTap,
            );
          },
        ),
      ],
    );
  }
}
