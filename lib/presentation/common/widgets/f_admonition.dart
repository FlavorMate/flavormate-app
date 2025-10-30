import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FAdmonition extends StatelessWidget {
  final Color color;
  final String content;
  final IconData icon;

  const FAdmonition({
    super.key,
    required this.color,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FCard(
      color: color,
      child: Row(
        spacing: PADDING / 2,
        children: [
          Icon(icon),
          Expanded(child: FText(content, style: FTextStyle.bodyMedium)),
        ],
      ),
    );
  }

  factory FAdmonition.warning({required String content}) {
    return FAdmonition(
      color: Colors.orange,
      content: content,
      icon: MdiIcons.alertCircleOutline,
    );
  }

  factory FAdmonition.error({required String content}) {
    return FAdmonition(
      color: Colors.red,
      content: content,
      icon: MdiIcons.closeOctagonOutline,
    );
  }
}
