import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FCircularAvatar extends StatelessWidget {
  final double width;
  final double height;
  final bool border;
  final double borderRadius;
  final String label;

  const FCircularAvatar({
    super.key,
    required this.label,
    this.border = false,
    this.borderRadius = BORDER_RADIUS,
    this.height = 64,
    this.width = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(PADDING / 4),
      decoration: BoxDecoration(
        border: border
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          label[0].toUpperCase(),
          style: TextStyle(
            height: 1,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            textBaseline: TextBaseline.ideographic,
          ),
        ),
      ),
    );
  }
}
