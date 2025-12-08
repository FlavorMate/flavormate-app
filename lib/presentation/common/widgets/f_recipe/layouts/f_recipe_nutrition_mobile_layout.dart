import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_nutrition_chart.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_nutrition_table.dart';
import 'package:flutter/material.dart';

class FRecipeNutritionMobileLayout extends StatefulWidget {
  final CommonNutrition? nutrition;
  final double amountFactor;
  final String servingLabel;

  const FRecipeNutritionMobileLayout({
    super.key,
    required this.nutrition,
    required this.amountFactor,
    required this.servingLabel,
  });

  @override
  State<FRecipeNutritionMobileLayout> createState() =>
      _FRecipeNutritionMobileLayoutState();
}

class _FRecipeNutritionMobileLayoutState
    extends State<FRecipeNutritionMobileLayout> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(context.l10n.f_recipe_nutrition_layout__title),
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
        if (widget.nutrition!.showChart)
          FRecipeNutritionChart(
            nutrition: widget.nutrition!,
            size: 256,
            onTouch: (val) => setState(() => _selectedIndex = val),
          ),
        Center(
          child: FRecipeNutritionTable(
            servingLabel: widget.servingLabel,
            amountFactor: widget.amountFactor,
            nutrition: widget.nutrition!,
            selected: _selectedIndex,
          ),
        ),
      ],
    );
  }
}
