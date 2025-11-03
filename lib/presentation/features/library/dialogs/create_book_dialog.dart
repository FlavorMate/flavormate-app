import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateBookDialog extends StatefulWidget {
  const CreateBookDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CreateBookDialogState();
}

class _CreateBookDialogState extends State<CreateBookDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      scrollable: true,
      title: L10n.of(context).create_book_dialog__title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: FTextFormField(
          controller: _controller,
          label: L10n.of(context).create_book_dialog__name,
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
