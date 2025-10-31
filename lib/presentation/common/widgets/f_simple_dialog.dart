import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FSimpleDialog<T> extends StatelessWidget {
  final String title;
  final List<FSimpleDialogOption<T>> options;

  const FSimpleDialog({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        ...options,
        const SizedBox(height: PADDING / 2),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsetsGeometry.only(right: PADDING),
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text(L10n.of(context).btn_close),
          ),
        ),
      ],
    );
  }
}

class FSimpleDialogOption<T> extends StatelessWidget {
  final T value;
  final String label;
  final IconData? icon;

  const FSimpleDialogOption({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () => context.pop(value),
      child: icon != null
          ? Row(
              spacing: PADDING,
              children: [Icon(icon), Text(label)],
            )
          : Text(label),
    );
  }
}
