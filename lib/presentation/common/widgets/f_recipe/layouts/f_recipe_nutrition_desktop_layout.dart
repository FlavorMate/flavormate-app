import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_nutrition_chart.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_nutrition_table.dart';
import 'package:flutter/material.dart';

class FRecipeNutritionDesktopLayout extends StatefulWidget {
  const FRecipeNutritionDesktopLayout({
    super.key,
    required this.nutrition,
    required this.amountFactor,
    required this.servingLabel,
  });

  final CommonNutrition? nutrition;
  final double amountFactor;
  final String servingLabel;

  @override
  State<FRecipeNutritionDesktopLayout> createState() =>
      _FRecipeNutritionDesktopLayoutState();
}

class _FRecipeNutritionDesktopLayoutState
    extends State<FRecipeNutritionDesktopLayout> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(L10n.of(context).f_recipe_nutrition_layout__title),
          ),
          if (widget.nutrition!.showChart)
            FRecipeNutritionChart(
              nutrition: widget.nutrition!,
              space: 1,
              size: 32,
              showLabels: false,
            ),
        ],
      ),
      shape: const Border(),
      childrenPadding: const EdgeInsets.symmetric(vertical: PADDING),
      children: [
        Row(
          spacing: PADDING,
          children: [
            Expanded(
              child: FRecipeNutritionTable(
                servingLabel: widget.servingLabel,
                amountFactor: widget.amountFactor,
                nutrition: widget.nutrition!,
                selected: _selectedIndex,
              ),
            ),
            if (widget.nutrition!.showChart)
              FRecipeNutritionChart(
                size: 256,
                space: 4,
                showLabels: true,
                nutrition: widget.nutrition!,
                onTouch: (val) => setState(() => _selectedIndex = val),
              ),
          ],
        ),
      ],
    );
  }
}
