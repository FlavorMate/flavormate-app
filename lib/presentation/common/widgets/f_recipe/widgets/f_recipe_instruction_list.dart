import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction_group.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

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
          FText(
            instructionGroup.label!,
            style: FTextStyle.titleLarge,
            fontWeight: .w500,
          ),

        for (final instruction in sortedInstructions)
          Row(
            spacing: PADDING,
            children: [
              _CheckedIndex(instruction: instruction),
              Flexible(child: Text(instruction.format(amountFactor))),
            ],
          ),
      ],
    );
  }
}

class _CheckedIndex extends StatefulWidget {
  const _CheckedIndex({
    required this.instruction,
  });

  final CommonInstruction instruction;

  @override
  State<StatefulWidget> createState() => _CheckedIndexState();
}

class _CheckedIndexState extends State<_CheckedIndex> {
  final double radius = 20;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(radius),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        color: context.colorScheme.primaryContainer,
        child: Stack(
          fit: .expand,
          children: [
            _selected
                ? const Icon(MdiIcons.check)
                : Center(
                    child: FText(
                      '${widget.instruction.index + 1}.',
                      style: .titleMedium,
                      color: .onPrimaryContainer,
                    ),
                  ),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: toggle,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggle() {
    setState(() {
      _selected = !_selected;
    });
  }
}
