import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction_group.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeInstructionList extends StatelessWidget {
  final CommonInstructionGroup instructionGroup;
  final double amountFactor;

  List<CommonInstruction> get sortedInstructions => instructionGroup
      .instructions
      .sorted((a, b) => a.index.compareTo(b.index));

  const FRecipeInstructionList({
    super.key,
    required this.instructionGroup,
    required this.amountFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        if (instructionGroup.label != null)
          FText(instructionGroup.label!, style: FTextStyle.titleLarge),

        for (final instruction in sortedInstructions)
          Row(
            spacing: PADDING,
            children: [
              CircleAvatar(child: Text('${instruction.index + 1}.')),
              Flexible(child: Text(_parseInstructions(instruction.label))),
            ],
          ),
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
        newValue = newValue * (amountFactor);
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
