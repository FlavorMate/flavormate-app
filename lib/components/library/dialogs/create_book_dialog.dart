import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_text_form_field.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
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
    return TAlertDialog(
      scrollable: true,
      title: L10n.of(context).d_library_create_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TTextFormField(
          controller: _controller,
          label: L10n.of(context).d_library_create_label,
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
