import 'package:flavormate/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsAppThemeTile extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final String label;
  final BorderRadiusGeometry borderRadiusGeometry;
  final void Function(Color) onTap;

  const SettingsAppThemeTile({
    super.key,
    required this.isSelected,
    required this.color,
    required this.label,
    this.borderRadiusGeometry = .zero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = calcColorForText(color);

    return Material(
      color: color,
      borderRadius: borderRadiusGeometry,
      child: ListTile(
        visualDensity: .standard,
        textColor: contentColor,
        leading: Icon(
          isSelected ? MdiIcons.checkCircleOutline : MdiIcons.circleOutline,
          color: contentColor,
        ),
        title: Text(label),
        onTap: () => onTap.call(color),
      ),
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
