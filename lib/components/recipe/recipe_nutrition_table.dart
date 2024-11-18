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

  const RecipeNutritionTable(
      {super.key,
      required this.serving,
      required this.factor,
      required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return TDataTable(
      columns: [
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
            cells: [
              Text(NutritionType.fat.getName(context)),
              Text(nutrition.fat!.beautify),
              Text(nutrition.fatPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.saturatedFat))
          TDataRow(
            cells: [
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
            cells: [
              Text(NutritionType.carbohydrates.getName(context)),
              Text(nutrition.carbohydrates!.beautify),
              Text(nutrition.carbohydratesPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.sugars))
          TDataRow(
            cells: [
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
            cells: [
              Text(NutritionType.fiber.getName(context)),
              Text(nutrition.fiber!.beautify),
              Text(nutrition.fiberPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.proteins))
          TDataRow(
            cells: [
              Text(NutritionType.proteins.getName(context)),
              Text(nutrition.proteins!.beautify),
              Text(nutrition.proteinsPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.salt))
          TDataRow(
            cells: [
              Text(NutritionType.salt.getName(context)),
              Text(nutrition.salt!.beautify),
              Text(nutrition.saltPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.sodium))
          TDataRow(
            cells: [
              Text(NutritionType.sodium.getName(context)),
              Text(nutrition.sodium!.beautify),
              Text(nutrition.sodiumPercent.beautify),
            ],
          ),
      ],
    );
  }
}
