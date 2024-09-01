import 'package:collection/collection.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/instructions/instruction_group.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class RecipeInstructions extends StatelessWidget {
  final List<InstructionGroup> instructionGroups;
  final double factor;
  final Serving serving;

  const RecipeInstructions({
    super.key,
    required this.instructionGroups,
    required this.factor,
    required this.serving,
  });

  @override
  Widget build(BuildContext context) {
    return TColumn(
      space: PADDING,
      children: [
        TText(
            L10n.of(context).c_recipe_instructions, TextStyles.headlineMedium),
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
    int lIndex = -1;
    int rIndex = -1;
    do {
      lIndex = value.indexOf('[[', lIndex + 1);
      rIndex = value.indexOf(']]', rIndex + 1);

      if (lIndex != -1) {
        var foundText = value.substring(lIndex + 2, rIndex);
        double newValue = double.tryParse(foundText) ?? 1;
        newValue = newValue * (factor / serving.amount);
        value = value.replaceAll(
          '[[$foundText]]',
          newValue % 1 == 0
              ? newValue.toStringAsFixed(0)
              : newValue.toStringAsFixed(2),
        );
      }
    } while (lIndex != -1);
    return value;
  }
}
