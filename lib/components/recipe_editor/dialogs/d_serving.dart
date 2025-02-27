import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text_form_field.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DServing extends StatefulWidget {
  final ServingDraft serving;

  const DServing({super.key, required this.serving});

  @override
  State<StatefulWidget> createState() => _DServingState();
}

class _DServingState extends State<DServing> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _labelController = TextEditingController();

  @override
  void initState() {
    _amountController.text =
        widget.serving.amount <= 0
            ? ''
            : widget.serving.amount.toInt().toString();
    _labelController.text = widget.serving.label;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_serving_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TColumn(
          children: [
            TTextFormField(
              controller: _amountController,
              label: L10n.of(context).d_editor_serving_amount,
              validators: (input) => UValidatorPresets.isNumber(context, input),
            ),
            TTextFormField(
              controller: _labelController,
              label: L10n.of(context).d_editor_serving_label,
              validators:
                  (input) => UValidatorPresets.isNotEmpty(context, input),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    final sd = ServingDraft(
      double.parse(_amountController.text),
      _labelController.text.trim(),
    );
    context.pop(sd);
  }
}
