import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TCircularAvatar extends StatelessWidget {
  final double width;
  final double height;
  final bool border;
  final double borderRadius;
  final double fontSize;
  final String label;

  const TCircularAvatar({
    super.key,
    required this.label,
    this.fontSize = 36,
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
      decoration: BoxDecoration(
        border:
            border
                ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
                : null,
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Center(
        child: Text(
          label[0],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
