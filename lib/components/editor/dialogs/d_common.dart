import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_full_dialog.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DCommon extends StatefulWidget {
  final String? label;
  final String? description;

  const DCommon({
    super.key,
    required this.label,
    required this.description,
  });

  @override
  State<StatefulWidget> createState() => _DCommonState();
}

class _DCommonState extends State<DCommon> {
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();

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
      child: TColumn(
        children: [
          TextField(
            controller: _labelController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(L10n.of(context).d_editor_common_label),
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(L10n.of(context).d_editor_common_description),
            ),
          ),
        ],
      ),
    );
  }

  void submit() {
    context.pop({
      'label': EString.trimToNull(_labelController.text),
      'description': EString.trimToNull(_descriptionController.text),
    });
  }
}
