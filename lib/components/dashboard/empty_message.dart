import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class EmptyMessage extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyMessage({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return TColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          MdiIcons.folderQuestionOutline,
          size: 96,
        ),
        TText(
          title,
          TextStyles.titleLarge,
        ),
        TText(
          subtitle,
          TextStyles.titleSmall,
        )
      ],
    );
  }
}
