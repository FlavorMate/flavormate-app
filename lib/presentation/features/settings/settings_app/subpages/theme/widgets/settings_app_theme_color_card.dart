import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsAppThemeColorCard extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const SettingsAppThemeColorCard({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card.outlined(
        color: context.colorScheme.surfaceContainer,
        margin: .zero,
        child: Container(
          padding: const .all(PADDING),
          child: Column(
            spacing: PADDING,
            children: [
              Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: .circular(BORDER_RADIUS),
                ),
              ),
              Row(
                mainAxisAlignment: .center,
                spacing: PADDING,
                children: [
                  Icon(
                    selected
                        ? MdiIcons.checkCircleOutline
                        : MdiIcons.circleOutline,
                  ),
                  FText(label, style: .bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
