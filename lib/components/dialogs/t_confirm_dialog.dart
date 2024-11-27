import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TConfirmDialog extends StatelessWidget {
  final String title;
  final String? content;

  const TConfirmDialog({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content != null ? Text(content!) : null,
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(L10n.of(context).btn_cancel),
        ),
        FilledButton(
          onPressed: () => context.pop(true),
          child: Text(L10n.of(context).btn_yes),
        ),
      ],
    );
  }
}
