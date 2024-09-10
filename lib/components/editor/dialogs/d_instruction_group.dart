import 'package:collection/collection.dart';
import 'package:flavormate/components/editor/dialogs/d_instruction.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_full_dialog.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_draft.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DInstructionGroup extends StatefulWidget {
  final InstructionGroupDraft instructionGroup;

  const DInstructionGroup({
    super.key,
    required this.instructionGroup,
  });

  @override
  State<StatefulWidget> createState() => _DInstructionGroupState();
}

class _DInstructionGroupState extends State<DInstructionGroup> {
  final _labelController = TextEditingController();

  late InstructionGroupDraft _instructionGroup;

  @override
  void initState() {
    _instructionGroup = widget.instructionGroup.copyWith();
    _labelController.text = _instructionGroup.label;
    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_instruction_group_title,
      submit: () => submit(context),
      child: TColumn(
        children: [
          TextField(
            controller: _labelController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text(L10n.of(context).d_editor_instruction_group_label),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label: Text(
                    L10n.of(context).d_editor_instruction_group_instruction,
                  ),
                ),
                DataColumn(label: Container()),
              ],
              rows: _instructionGroup.instructions
                  .mapIndexed(
                    (index, instruction) => DataRow(
                      onSelectChanged: (_) => openInstruction(instruction),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              instruction.label.isEmpty
                                  ? '-'
                                  : instruction.label.shorten(),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: IconButton(
                              onPressed: () => deleteInstruction(instruction),
                              icon: Icon(
                                MdiIcons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          FilledButton.tonal(
            onPressed: createInstruction,
            child: Text(
              L10n.of(context).d_editor_instruction_group_add_instruction,
            ),
          )
        ],
      ),
    );
  }

  void openInstruction(InstructionDraft instruction) async {
    final response = await showDialog(
      context: context,
      builder: (_) => DInstruction(instruction: instruction.copyWith()),
    );

    if (response == null) return;

    final index = _instructionGroup.instructions.indexOf(instruction);
    setState(() {
      _instructionGroup.instructions[index] = response;
    });
  }

  void createInstruction() {
    setState(() {
      _instructionGroup.instructions.add(InstructionDraft(label: ''));
    });
  }

  void deleteInstruction(InstructionDraft group) {
    setState(() {
      _instructionGroup.instructions.remove(group);
    });
  }

  void submit(BuildContext context) {
    _instructionGroup.label = _labelController.text.trim();
    context.pop(_instructionGroup);
  }
}
