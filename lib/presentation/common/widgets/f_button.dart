import 'package:flutter/material.dart';

class FButton extends StatelessWidget {
  final Widget? trailing;
  final String label;
  final Widget? leading;

  final bool tonal;

  final VoidCallback? onPressed;

  final double? width, height;

  const FButton({
    required this.label,
    required this.onPressed,
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
      child: tonal
          ? FilledButton.tonal(
              onPressed: onPressed,
              child: _FButtonInternal(
                label: label,
                leading: leading,
                trailing: trailing,
              ),
            )
          : FilledButton(
              onPressed: onPressed,
              child: _FButtonInternal(
                label: label,
                leading: leading,
                trailing: trailing,
              ),
            ),
    );
  }
}

class _FButtonInternal extends StatelessWidget {
  final Widget? leading;
  final String label;
  final Widget? trailing;

  const _FButtonInternal({
    this.leading,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) leading!,
        Expanded(child: Text(label, textAlign: TextAlign.center)),
        if (trailing != null) trailing!,
      ],
    );
  }
}
