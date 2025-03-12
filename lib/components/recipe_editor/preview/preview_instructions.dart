import 'package:collection/collection.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PreviewInstructions extends StatelessWidget {
  final List<InstructionGroupDraft> instructionGroups;
  final ServingDraft serving;

  const PreviewInstructions({
    super.key,
    required this.instructionGroups,
    required this.serving,
  });

  @override
  Widget build(BuildContext context) {
    return TColumn(
      space: PADDING,
      children: [
        TText(
          L10n.of(context).c_recipe_instructions,
          TextStyles.headlineMedium,
        ),
        ...List.generate(instructionGroups.length, (index) {
          final group = instructionGroups.elementAt(index);
          return [
            TColumn(
              space: PADDING,
              children: [
                if (group.label != null)
                  TText(group.label!, TextStyles.titleLarge),
                for (int i = 0; i < group.instructions.length; i++)
                  TRow(
                    space: PADDING,
                    children: [
                      CircleAvatar(child: Text('${i + 1}.')),
                      Flexible(
                        child: Text(
                          _parseInstructions(
                            group.instructions.elementAt(i).label,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (index < instructionGroups.length - 1)
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.65,
                child: const Divider(),
              ),
          ];
        }).flattened,
      ],
    );
  }

  String _parseInstructions(String value) {
    value = value.replaceAll('[[', '');
    value = value.replaceAll(']]', '');
    return value;
  }
}
