import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class TEmptyMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const TEmptyMessage({
    super.key,
    required this.title,
    this.icon = MdiIcons.folderQuestionOutline,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return TColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 96),
        TText(title, TextStyles.titleLarge, textAlign: TextAlign.center),
        if (subtitle != null)
          TText(subtitle!, TextStyles.titleSmall, textAlign: TextAlign.center),
      ],
    );
  }
}
