import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient_group.dart';
import 'package:flavormate/presentation/common/widgets/f_table.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeIngredientList extends StatelessWidget {
  final CommonIngredientGroup ingredientGroup;
  final double factor;
  final bool checkable;

  List<CommonIngredient> get sortedIngredients =>
      ingredientGroup.ingredients.sorted((a, b) => a.index.compareTo(b.index));

  const FRecipeIngredientList({
    super.key,
    required this.ingredientGroup,
    required this.factor,
    this.checkable = false,
  });

  @override
  Widget build(BuildContext context) {
    print([if (checkable) 0.1, 0.25, 0.75]);
    return Column(
      spacing: PADDING,
      children: [
        if (ingredientGroup.label != null)
          FText(
            ingredientGroup.label!,
            style: FTextStyle.titleLarge,
            fontWeight: FontWeight.w500,
          ),

        FTable(
          header: [
            if (checkable) const SizedBox.shrink(),
            FText(
              context.l10n.f_recipe_ingredient_list__amount,
              style: .titleMedium,
              textAlign: .end,
            ),
            FText(
              context.l10n.f_recipe_ingredient_list__ingredient,
              style: .titleMedium,
              textAlign: .left,
            ),
          ],
          rows: [
            for (final ingredient in sortedIngredients)
              [
                if (checkable) _CheckedIndex(),
                FText(
                  ingredient.getAmountLabel(factor),
                  style: .bodyMedium,
                  textAlign: .end,
                ),
                FText(
                  ingredient.label,
                  style: .bodyMedium,
                  textAlign: .left,
                ),
              ],
          ],
          distributions: checkable ? [0.1, 0.3, 0.6] : [0.3, 0.7],
        ),
      ],
    );
  }
}

class _CheckedIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckedIndexState();
}

class _CheckedIndexState extends State<_CheckedIndex> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(value: _selected, onChanged: toggle);
  }

  void toggle(bool? val) {
    setState(() {
      _selected = val ?? false;
    });
  }
}
