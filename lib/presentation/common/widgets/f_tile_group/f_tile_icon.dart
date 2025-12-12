import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

class FTileIcon extends StatelessWidget {
  final IconData icon;
  final Color? iconBackgroundColor;

  const FTileIcon({super.key, required this.icon, this.iconBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor:
          iconBackgroundColor ?? context.colorScheme.primaryContainer,
      child: Icon(
        icon,
        size: 24,
        color: context.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
