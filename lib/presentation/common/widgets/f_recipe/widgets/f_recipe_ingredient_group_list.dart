import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient_group.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_list.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FRecipeIngredientGroupList extends StatelessWidget {
  final List<CommonIngredientGroup> ingredientGroups;

  final void Function() decreaseServing;
  final void Function() increaseServing;

  final double amountFactor;
  final double newAmount;
  final String servingLabel;

  const FRecipeIngredientGroupList({
    super.key,
    required this.ingredientGroups,
    required this.decreaseServing,
    required this.increaseServing,
    required this.amountFactor,
    required this.newAmount,
    required this.servingLabel,
  });

  List<CommonIngredientGroup> get sortedIngredientGroups =>
      ingredientGroups.sorted((a, b) => a.index.compareTo(b.index));

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        FText(
          L10n.of(context).f_recipe_ingredient_group_list__title,
          style: FTextStyle.headlineMedium,
        ),

        Row(
          spacing: PADDING,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FIconButton(onPressed: decreaseServing, icon: MdiIcons.minus),
            Text('${newAmount.beautify} $servingLabel'),
            FIconButton(onPressed: increaseServing, icon: MdiIcons.plus),
          ],
        ),

        for (final ingredientGroup in sortedIngredientGroups)
          FRecipeIngredientList(
            ingredientGroup: ingredientGroup,
            factor: amountFactor,
          ),
      ],
    );
  }
}
