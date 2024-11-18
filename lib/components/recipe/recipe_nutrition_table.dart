import 'package:flavormate/components/t_data_table.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_double.dart';
import 'package:flutter/material.dart';

class RecipeNutritionTable extends StatelessWidget {
  final Serving serving;
  final double factor;
  final Nutrition nutrition;

  final int selected;

  const RecipeNutritionTable({
    super.key,
    required this.serving,
    required this.factor,
    required this.nutrition,
    this.selected = -1,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primaryContainer;

    return TDataTable(
      columns: [
        TDataColumn(
          alignment: Alignment.centerLeft,
          width: 24,
        ),
        TDataColumn(
          alignment: Alignment.centerLeft,
          child: Text(L10n.of(context).d_nutrition_title),
        ),
        TDataColumn(
          alignment: Alignment.centerRight,
          width: 92,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(serving.amount * factor).beautify} ${serving.label}',
                overflow: TextOverflow.ellipsis,
              ),
              Text('(g / ml)')
            ],
          ),
        ),
        TDataColumn(
          alignment: Alignment.centerRight,
          width: 48,
          child: Text('%'),
        ),
      ],
      rows: [
        if (UDouble.isPositive(nutrition.fat))
          TDataRow(
            background: selected == 0 ? selectedColor : null,
            cells: [
              Icon(NutritionType.fat.icon),
              Text(NutritionType.fat.getName(context)),
              Text(nutrition.fat!.beautify),
              Text(nutrition.fatPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.saturatedFat))
          TDataRow(
            background: selected == 0 ? selectedColor : null,
            cells: [
              Icon(NutritionType.saturatedFat.icon),
              Padding(
                padding: const EdgeInsets.only(left: PADDING),
                child: Text(NutritionType.saturatedFat.getName(context)),
              ),
              Text(nutrition.saturatedFat!.beautify),
              Text(nutrition.saturatedFatPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.carbohydrates))
          TDataRow(
            background: selected == 1 ? selectedColor : null,
            cells: [
              Icon(NutritionType.carbohydrates.icon),
              Text(NutritionType.carbohydrates.getName(context)),
              Text(nutrition.carbohydrates!.beautify),
              Text(nutrition.carbohydratesPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.sugars))
          TDataRow(
            background: selected == 1 ? selectedColor : null,
            cells: [
              Icon(NutritionType.sugars.icon),
              Padding(
                padding: const EdgeInsets.only(left: PADDING),
                child: Text(NutritionType.sugars.getName(context)),
              ),
              Text(nutrition.sugars!.beautify),
              Text(nutrition.sugarsPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.fiber))
          TDataRow(
            background: selected == 2 ? selectedColor : null,
            cells: [
              Icon(NutritionType.fiber.icon),
              Text(NutritionType.fiber.getName(context)),
              Text(nutrition.fiber!.beautify),
              Text(nutrition.fiberPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.proteins))
          TDataRow(
            background: selected == 3 ? selectedColor : null,
            cells: [
              Icon(NutritionType.proteins.icon),
              Text(NutritionType.proteins.getName(context)),
              Text(nutrition.proteins!.beautify),
              Text(nutrition.proteinsPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.salt))
          TDataRow(
            background: selected == 4 ? selectedColor : null,
            cells: [
              Icon(NutritionType.salt.icon),
              Text(NutritionType.salt.getName(context)),
              Text(nutrition.salt!.beautify),
              Text(nutrition.saltPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.sodium))
          TDataRow(
            background: selected == 5 ? selectedColor : null,
            cells: [
              Icon(NutritionType.sodium.icon),
              Text(NutritionType.sodium.getName(context)),
              Text(nutrition.sodium!.beautify),
              Text(nutrition.sodiumPercent.beautify),
            ],
          ),
      ],
    );
  }
}
