import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/data/models/shared/enums/nutrition_type.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_data_table.dart';
import 'package:flutter/material.dart';

class FRecipeNutritionTable extends StatelessWidget {
  final double amountFactor;
  final String servingLabel;

  final CommonNutrition nutrition;

  final int selected;

  const FRecipeNutritionTable({
    super.key,
    required this.amountFactor,
    required this.servingLabel,
    required this.nutrition,
    this.selected = -1,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primaryContainer;

    return FDataTable(
      columns: [
        FDataColumn(alignment: Alignment.centerLeft, width: 24),
        FDataColumn(
          alignment: Alignment.centerLeft,
          child: Text(context.l10n.f_recipe_nutrition_table__title),
        ),
        FDataColumn(
          alignment: Alignment.centerRight,
          width: 92,
          child: Text(
            '${(amountFactor).beautify} $servingLabel',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        FDataColumn(
          alignment: Alignment.centerRight,
          width: 48,
          child: const Text('%'),
        ),
      ],
      rows: [
        if (UDouble.isPositive(nutrition.energyKcal))
          FDataRow(
            cells: [
              Icon(NutritionType.energyKcal.icon),
              Text(NutritionType.energyKcal.getName(context)),
              Text('${nutrition.energyKcal!.beautify} kcal'),
              const SizedBox.shrink(),
            ],
          ),
        if (UDouble.isPositive(nutrition.carbohydrates))
          FDataRow(
            background: selected == 0 ? selectedColor : null,
            cells: [
              Icon(NutritionType.carbohydrates.icon),
              Text(NutritionType.carbohydrates.getName(context)),
              Text('${nutrition.carbohydrates!.beautify} g'),
              Text(nutrition.carbohydratesPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.sugars))
          FDataRow(
            background: selected == 0 ? selectedColor : null,
            cells: [
              Icon(NutritionType.sugars.icon),
              Padding(
                padding: const EdgeInsets.only(left: PADDING),
                child: Text(NutritionType.sugars.getName(context)),
              ),
              Text('${nutrition.sugars!.beautify} g'),
              Text(nutrition.sugarsPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.fat))
          FDataRow(
            background: selected == 1 ? selectedColor : null,
            cells: [
              Icon(NutritionType.fat.icon),
              Text(NutritionType.fat.getName(context)),
              Text('${nutrition.fat!.beautify} g'),
              Text(nutrition.fatPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.saturatedFat))
          FDataRow(
            background: selected == 1 ? selectedColor : null,
            cells: [
              Icon(NutritionType.saturatedFat.icon),
              Padding(
                padding: const EdgeInsets.only(left: PADDING),
                child: Text(NutritionType.saturatedFat.getName(context)),
              ),
              Text('${nutrition.saturatedFat!.beautify} g'),
              Text(nutrition.saturatedFatPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.fiber))
          FDataRow(
            background: selected == 2 ? selectedColor : null,
            cells: [
              Icon(NutritionType.fiber.icon),
              Text(NutritionType.fiber.getName(context)),
              Text('${nutrition.fiber!.beautify} g'),
              Text(nutrition.fiberPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.proteins))
          FDataRow(
            background: selected == 3 ? selectedColor : null,
            cells: [
              Icon(NutritionType.proteins.icon),
              Text(NutritionType.proteins.getName(context)),
              Text('${nutrition.proteins!.beautify} g'),
              Text(nutrition.proteinsPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.salt))
          FDataRow(
            background: selected == 4 ? selectedColor : null,
            cells: [
              Icon(NutritionType.salt.icon),
              Text(NutritionType.salt.getName(context)),
              Text('${nutrition.salt!.beautify} g'),
              Text(nutrition.saltPercent.beautify),
            ],
          ),
        if (UDouble.isPositive(nutrition.sodium))
          FDataRow(
            background: selected == 5 ? selectedColor : null,
            cells: [
              Icon(NutritionType.sodium.icon),
              Text(NutritionType.sodium.getName(context)),
              Text('${nutrition.sodium!.beautify} g'),
              Text(nutrition.sodiumPercent.beautify),
            ],
          ),
      ],
    );
  }
}
