import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction_group.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_instruction_list.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeInstructionGroupList extends StatelessWidget {
  final List<CommonInstructionGroup> instructionGroups;
  final double amountFactor;

  List<CommonInstructionGroup> get sortedInstructionGroups =>
      instructionGroups.sorted((a, b) => a.index.compareTo(b.index));

  const FRecipeInstructionGroupList({
    super.key,
    required this.instructionGroups,
    required this.amountFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        FText(
          context.l10n.f_recipe_instruction_group_list__title,
          style: FTextStyle.headlineMedium,
          weight: FontWeight.w500,
        ),
        Column(
          spacing: PADDING * 2,
          children: [
            for (final group in sortedInstructionGroups)
              FRecipeInstructionList(
                instructionGroup: group,
                amountFactor: amountFactor,
              ),
          ],
        ),
      ],
    );
  }
}
