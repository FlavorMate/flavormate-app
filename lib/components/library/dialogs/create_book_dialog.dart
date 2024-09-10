import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
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
    return TAlertDialog(
      title: L10n.of(context).d_library_create_title,
      submit: submit,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text(L10n.of(context).d_library_create_label),
        ),
      ),
    );
  }

  void submit() {
    context.pop(_controller.text);
  }
}
