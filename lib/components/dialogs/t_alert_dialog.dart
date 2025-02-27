import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TAlertDialog extends StatelessWidget {
  final bool scrollable;

  final String title;
  final Widget child;

  final double width;
  final double? height;

  final VoidCallback? submit;

  final String? negativeLabel;
  final String? positiveLabel;

  const TAlertDialog({
    super.key,
    this.scrollable = false,
    required this.title,
    required this.child,
    this.width = 300,
    this.height,
    this.submit,
    this.negativeLabel,
    this.positiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: scrollable,
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(negativeLabel ?? L10n.of(context).btn_cancel),
        ),
        if (submit != null)
          FilledButton(
            onPressed: submit,
            child: Text(positiveLabel ?? L10n.of(context).btn_save),
          ),
      ],
      content: SizedBox(width: width, height: height, child: child),
    );
  }
}
