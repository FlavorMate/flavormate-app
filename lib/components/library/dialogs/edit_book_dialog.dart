import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditBookDialog extends StatefulWidget {
  final String label;

  const EditBookDialog({super.key, required this.label});

  @override
  State<StatefulWidget> createState() => _EditBookDialogState();
}

class _EditBookDialogState extends State<EditBookDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: L10n.of(context).d_library_edit_title,
      submit: submit,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text(L10n.of(context).d_library_edit_name),
        ),
      ),
    );
  }

  void submit() {
    context.pop(_controller.text);
  }
}
