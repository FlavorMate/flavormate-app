import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FImageError extends StatelessWidget {
  const FImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        color: Color.lerp(
          Theme.of(context).colorScheme.inversePrimary,
          Colors.black,
          0.15,
        ),
      ),
      child: const Icon(
        MdiIcons.cameraOffOutline,
        size: 64,
        color: Colors.white,
      ),
    );
  }
}
