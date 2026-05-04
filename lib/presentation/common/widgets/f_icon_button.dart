import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  final String? label;
  final double? width;
  final double height;

  const FIconButton({
    required this.onPressed,
    required this.icon,
    this.label,
    this.height = 48,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: IconButton(
          color: FTextColor.filledButton.getThemeColor(context),
          icon: Icon(icon),
          onPressed: onPressed,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(minimumSize: .fromHeight(height)),
          child: Row(
            spacing: PADDING / 2,
            children: [
              Icon(icon),
              Expanded(child: Text(label!, textAlign: TextAlign.center)),
            ],
          ),
        ),
      );
    }
  }
}
