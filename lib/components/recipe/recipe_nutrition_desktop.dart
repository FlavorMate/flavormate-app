import 'package:flavormate/components/recipe/recipe_nutrition_chart.dart';
import 'package:flavormate/components/recipe/recipe_nutrition_table.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class RecipeNutritionDesktop extends StatefulWidget {
  const RecipeNutritionDesktop({
    super.key,
    required this.nutrition,
    required this.serving,
    required this.servingFactor,
  });

  final Nutrition? nutrition;
  final Serving serving;
  final double servingFactor;

  @override
  State<RecipeNutritionDesktop> createState() => _RecipeNutritionDesktopState();
}

class _RecipeNutritionDesktopState extends State<RecipeNutritionDesktop> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(L10n.of(context).d_nutrition_title),
          ),
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
        TRow(
          children: [
            Expanded(
              child: RecipeNutritionTable(
                serving: widget.serving,
                factor: widget.servingFactor,
                nutrition: widget.nutrition!,
                selected: _selectedIndex,
              ),
            ),
            if (widget.nutrition!.showChart)
              RecipeNutritionChart(
                size: 256,
                space: 4,
                showLabels: true,
                nutrition: widget.nutrition!,
                onTouch: (val) => setState(() => _selectedIndex = val),
              ),
          ],
        )
      ],
    );
  }
}
