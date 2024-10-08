import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';

class TIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  final String? label;
  final double? width, height;

  const TIconButton({
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
          color: TText.getColor(context, TextColor.filledButton),
          icon: Icon(icon),
          onPressed: onPressed,
        ),
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: FilledButton(
          onPressed: onPressed,
          child: Row(
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
