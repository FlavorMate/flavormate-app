import 'package:flavormate/components/recipe/recipe_nutrition_chart.dart';
import 'package:flavormate/components/recipe/recipe_nutrition_table.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class RecipeNutrition extends StatelessWidget {
  final Nutrition? nutrition;
  final double factor;
  final Serving serving;

  const RecipeNutrition({
    super.key,
    required this.nutrition,
    required this.factor,
    required this.serving,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(child: Text(L10n.of(context).d_nutrition_title)),
          RecipeNutritionChart(
            nutrition: nutrition!,
            space: 1,
            size: 32,
            showLabels: false,
          ),
        ],
      ),
      shape: const Border(),
      childrenPadding: EdgeInsets.symmetric(vertical: PADDING),
      children: [
        RecipeNutritionChart(
          nutrition: nutrition!,
          size: 256,
        ),
        Center(
          child: RecipeNutritionTable(
            serving: serving,
            factor: factor,
            nutrition: nutrition!,
          ),
        ),
      ],
    );
  }
}
