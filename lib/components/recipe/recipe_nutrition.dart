import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_double.dart';
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
    return Wrap(
      spacing: PADDING,
      runSpacing: PADDING,
      alignment: WrapAlignment.center,
      children: [
        if (UDouble.isPositive(nutrition?.carbohydrates))
          NutritionCard(
            amount: nutrition!.carbohydrates!,
            nutritionType: NutritionType.carbohydrates,
          ),
        if (UDouble.isPositive(nutrition?.energyKcal))
          NutritionCard(
            amount: nutrition!.energyKcal!,
            nutritionType: NutritionType.energyKcal,
          ),
        if (UDouble.isPositive(nutrition?.fat))
          NutritionCard(
            amount: nutrition!.fat!,
            nutritionType: NutritionType.fat,
          ),
        if (UDouble.isPositive(nutrition?.saturatedFat))
          NutritionCard(
            amount: nutrition!.saturatedFat!,
            nutritionType: NutritionType.saturatedFat,
          ),
        if (UDouble.isPositive(nutrition?.sugars))
          NutritionCard(
            amount: nutrition!.sugars!,
            nutritionType: NutritionType.sugars,
          ),
        if (UDouble.isPositive(nutrition?.fiber))
          NutritionCard(
            amount: nutrition!.fiber!,
            nutritionType: NutritionType.fiber,
          ),
        if (UDouble.isPositive(nutrition?.proteins))
          NutritionCard(
            amount: nutrition!.proteins!,
            nutritionType: NutritionType.proteins,
          ),
        if (UDouble.isPositive(nutrition?.salt))
          NutritionCard(
            amount: nutrition!.salt!,
            nutritionType: NutritionType.salt,
          ),
        if (UDouble.isPositive(nutrition?.sodium))
          NutritionCard(
            amount: nutrition!.sodium!,
            nutritionType: NutritionType.sodium,
          ),
      ],
    );
  }
}

class NutritionCard extends StatelessWidget {
  const NutritionCard({
    super.key,
    required this.amount,
    required this.nutritionType,
  });

  final double amount;
  final NutritionType nutritionType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TCard(
        child: TRow(
          children: [
            Icon(nutritionType.icon),
            Expanded(
              child: TColumn(
                space: PADDING / 2,
                children: [
                  TText(nutritionType.getName(context), TextStyles.titleLarge),
                  TText('${amount.beautify} g / ml', TextStyles.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
