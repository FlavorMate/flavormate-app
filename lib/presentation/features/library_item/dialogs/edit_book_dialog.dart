import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller.text = widget.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: L10n.of(context).edit_book_dialog__title(widget.label),
      submit: submit,
      child: Form(
        key: _formKey,
        child: FTextFormField(
          controller: _controller,
          label: L10n.of(context).edit_book_dialog__name,
          validators: (input) => UValidatorPresets.isNotEmpty(context, input),
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    context.pop(_controller.text);
  }
}
