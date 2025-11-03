import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsThemeColorCard extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final bool selected;

  const SettingsThemeColorCard({
    super.key,
    required this.onTap,
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: PADDING * 2,
        backgroundColor: color,
        foregroundColor: Colors.white,
        child: selected ? const Icon(MdiIcons.check) : null,
      ),
    );
  }
}
