import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FStateChip extends StatelessWidget {
  final bool active;
  final String label;

  const FStateChip({
    super.key,
    required this.active,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = active
        ? context.blendedColors.success
        : context.blendedColors.error;
    final icon = active
        ? MdiIcons.checkCircleOutline
        : MdiIcons.closeCircleOutline;

    final color = context.colorScheme.onPrimary;

    return Chip(
      backgroundColor: backgroundColor,
      avatar: Icon(
        icon,
        color: color,
      ),
      labelStyle: TextStyle(color: color),
      label: Text(label),
    );
  }
}
