import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text_form_field.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DCommon extends StatefulWidget {
  final String? label;
  final String? description;

  const DCommon({super.key, required this.label, required this.description});

  @override
  State<StatefulWidget> createState() => _DCommonState();
}

class _DCommonState extends State<DCommon> {
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _labelController.text = widget.label ?? '';
    _descriptionController.text = widget.description ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_common_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TColumn(
          children: [
            TTextFormField(
              controller: _labelController,
              label: L10n.of(context).d_editor_common_label,
              validators:
                  (input) => UValidatorPresets.isNotEmpty(context, input),
            ),
            TTextFormField(
              controller: _descriptionController,
              label: L10n.of(context).d_editor_common_description,
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    context.pop({
      'label': EString.trimToNull(_labelController.text),
      'description': EString.trimToNull(_descriptionController.text),
    });
  }
}
