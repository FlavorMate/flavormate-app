import 'package:flutter/material.dart';

class TButton extends StatelessWidget {
  final Widget? trailing;
  final String label;
  final Widget? leading;

  final bool tonal;

  final VoidCallback? onPressed;

  final double? width, height;

  const TButton({
    required this.onPressed,
    required this.label,
    this.tonal = false,
    this.trailing,
    this.leading,
    this.height = 48,
    this.width = double.infinity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child:
          tonal
              ? FilledButton.tonal(
                onPressed: onPressed,
                child: Row(
                  children: [
                    if (leading != null) leading!,
                    Expanded(child: Text(label, textAlign: TextAlign.center)),
                    if (trailing != null) trailing!,
                  ],
                ),
              )
              : FilledButton(
                onPressed: onPressed,
                child: Row(
                  children: [
                    if (leading != null) leading!,
                    Expanded(child: Text(label, textAlign: TextAlign.center)),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
    );
  }
}
