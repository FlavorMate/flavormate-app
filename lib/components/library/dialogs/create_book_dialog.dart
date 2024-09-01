import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateBookDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateBookDialogState();
}

class _CreateBookDialogState extends State<CreateBookDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.of(context).d_library_create_title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text(L10n.of(context).d_library_create_label),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(L10n.of(context).btn_cancel),
        ),
        FilledButton(
          onPressed: () => context.pop(_controller.text),
          child: Text(L10n.of(context).btn_create),
        ),
      ],
    );
  }
}
