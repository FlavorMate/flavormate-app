import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_draft.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DInstruction extends StatefulWidget {
  final InstructionDraft instruction;

  const DInstruction({super.key, required this.instruction});

  @override
  State<StatefulWidget> createState() => _DInstructionState();
}

class _DInstructionState extends State<DInstruction> {
  final _formKey = GlobalKey<FormState>();

  late InstructionDraft _instruction;

  final _instructionController = TextEditingController();

  @override
  void initState() {
    _instruction = widget.instruction.copyWith();

    _instructionController.text = _instruction.label;
    super.initState();
  }

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      scrollable: true,
      title: L10n.of(context).d_editor_instruction_title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _instructionController,
              minLines: null,
              maxLines: null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_editor_instruction_label),
              ),
              validator: (input) {
                if (UValidator.isEmpty(input)) {
                  return L10n.of(context).v_isEmpty;
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    context.pop(InstructionDraft(label: _instructionController.text.trim()));
  }
}
