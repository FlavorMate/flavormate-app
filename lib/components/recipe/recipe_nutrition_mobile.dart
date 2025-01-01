import 'package:flavormate/components/recipe/recipe_nutrition_chart.dart';
import 'package:flavormate/components/recipe/recipe_nutrition_table.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class RecipeNutrition extends StatefulWidget {
  final Nutrition? nutrition;
  final double servingFactor;
  final Serving serving;

  const RecipeNutrition({
    super.key,
    required this.nutrition,
    required this.servingFactor,
    required this.serving,
  });

  @override
  State<RecipeNutrition> createState() => _RecipeNutritionState();

  double get factor => servingFactor / serving.amount;
}

class _RecipeNutritionState extends State<RecipeNutrition> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(child: Text(L10n.of(context).d_nutrition_title)),
          if (widget.nutrition!.showChart)
            RecipeNutritionChart(
              nutrition: widget.nutrition!,
              space: 1,
              size: 32,
              showLabels: false,
            ),
        ],
      ),
      shape: const Border(),
      childrenPadding: EdgeInsets.symmetric(vertical: PADDING),
      children: [
        if (widget.nutrition!.showChart)
          RecipeNutritionChart(
            nutrition: widget.nutrition!,
            size: 256,
            onTouch: (val) => setState(() => _selectedIndex = val),
          ),
        Center(
          child: RecipeNutritionTable(
            serving: widget.serving,
            factor: widget.factor,
            nutrition: widget.nutrition!,
            selected: _selectedIndex,
          ),
        ),
      ],
    );
  }
}
