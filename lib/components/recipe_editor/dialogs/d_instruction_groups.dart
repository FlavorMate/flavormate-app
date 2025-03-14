import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/recipe_editor/dialogs/d_instruction_group.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_data_table.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DInstructionGroups extends StatefulWidget {
  final List<InstructionGroupDraft> instructionGroups;

  const DInstructionGroups({super.key, required this.instructionGroups});

  @override
  State<StatefulWidget> createState() => _DInstructionGroupsState();
}

class _DInstructionGroupsState extends State<DInstructionGroups> {
  late List<InstructionGroupDraft> _instructionGroups;

  @override
  void initState() {
    _instructionGroups =
        widget.instructionGroups.map((iG) => iG.copyWith()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_instruction_groups_title,
      submit: () => submit(context),
      child: TColumn(
        children: [
          TDataTable(
            columns: [
              TDataColumn(
                alignment: Alignment.centerLeft,
                child: Text(L10n.of(context).d_editor_instruction_groups_label),
              ),
              TDataColumn(width: TABLE_ICON_WIDTH),
            ],
            rows: [
              for (final (index, group) in _instructionGroups.indexed)
                TDataRow(
                  onSelectChanged: (_) => openGroup(group),
                  cells: [
                    Text(getName(context, group.label, index)),
                    IconButton(
                      onPressed: () => deleteGroup(group),
                      icon: Icon(MdiIcons.delete, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
          FilledButton.tonal(
            onPressed: createGroup,
            child: Text(
              L10n.of(context).d_editor_instruction_groups_create_group,
            ),
          ),
        ],
      ),
    );
  }

  String getName(BuildContext context, String? val, int index) {
    if (val?.isEmpty ?? true) {
      return L10n.of(
        context,
      ).d_editor_instruction_groups_label_2('${index + 1}');
    } else {
      return val!;
    }
  }

  void openGroup(InstructionGroupDraft group) async {
    final response = await showDialog<InstructionGroupDraft>(
      context: context,
      builder: (_) => DInstructionGroup(instructionGroup: group.copyWith()),
      useSafeArea: false,
    );

    if (response == null) return;

    final index = _instructionGroups.indexOf(group);
    setState(() {
      _instructionGroups[index] = response;
    });
  }

  void createGroup() {
    final instructionGroup = InstructionGroupDraft(instructions: []);

    setState(() => _instructionGroups.add(instructionGroup));

    openGroup(instructionGroup);
  }

  void deleteGroup(InstructionGroupDraft group) {
    setState(() {
      _instructionGroups.remove(group);
    });
  }

  void submit(BuildContext context) {
    context.pop(_instructionGroups);
  }
}
