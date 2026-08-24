import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction_group.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
    return M3EButton(
      style: .text,
      onPressed: toggle,
      decoration: .styleFrom(
        backgroundColor: context.colorScheme.primaryContainer,
        minimumSize: .new(radius * 2, radius * 2),
        maximumSize: .new(radius * 2, radius * 2),
        padding: .zero,
      ),

      child: _selected
          ? const Icon(Symbols.check_rounded)
          : Center(
              child: FText(
                '${widget.instruction.index + 1}.',
                style: .titleMedium,
                color: .onPrimaryContainer,
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
