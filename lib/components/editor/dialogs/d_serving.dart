import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_full_dialog.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DServing extends StatefulWidget {
  final ServingDraft serving;

  const DServing({
    super.key,
    required this.serving,
  });

  @override
  State<StatefulWidget> createState() => _DServingState();
}

class _DServingState extends State<DServing> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _labelController = TextEditingController();

  @override
  void initState() {
    _amountController.text = widget.serving.amount <= 0
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
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_serving_amount),
              ),
              validator: (input) {
                if (UValidator.isEmpty(input)) {
                  return L10n.of(context).v_isEmpty;
                }

                if (!UValidator.isNumber(input!)) {
                  return L10n.of(context).v_isNumber;
                }

                return null;
              },
            ),
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_serving_label),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    final sd = ServingDraft(
      double.parse(_amountController.text),
      _labelController.text.trim(),
    );
    context.pop(sd);
  }
}
