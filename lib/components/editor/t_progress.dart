import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class TProgress extends StatelessWidget {
  final bool optional;
  final double completed;

  const TProgress({
    super.key,
    required this.completed,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    if (completed <= 0) {
      if (optional) {
        return const Icon(MdiIcons.minusCircleOutline);
      } else {
        return const Icon(MdiIcons.alertCircleOutline);
      }
    } else if (completed >= 100) {
      return const Icon(MdiIcons.checkCircleOutline);
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 4),
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            value: completed / 100,
            strokeWidth: 3,
            color: TText.getColor(
              context,
              TextColor.filledButton,
            ),
          ),
        ),
      );
    }
  }
}
