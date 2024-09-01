import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;

  const ConfirmDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
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
