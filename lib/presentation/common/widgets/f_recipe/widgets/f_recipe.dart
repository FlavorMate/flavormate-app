import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_unit_conversions.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/layouts/f_recipe_desktop_layout.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/layouts/f_recipe_mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FRecipe extends ConsumerStatefulWidget {
  final CommonRecipe recipe;
  final bool enableBookmark;
  final bool enableBring;
  final bool enableReview;
  final bool readOnly;
  final bool hasFab;

  final VoidCallback showAllFiles;

  final VoidCallback? addToBring;
  final VoidCallback? addBookmark;
  final Function(double?)? setRating;

  const FRecipe({
    super.key,
    required this.recipe,
    required this.enableBookmark,
    required this.enableBring,
    required this.enableReview,
    required this.readOnly,
    required this.showAllFiles,
    this.addToBring,
    this.addBookmark,
    this.setRating,
    this.hasFab = false,
  });

  @override
  ConsumerState<FRecipe> createState() => _FRecipeState();
}

class _FRecipeState extends ConsumerState<FRecipe> {
  double defaultAmount = -1;
  double newAmount = -1;

  double get amountFactor => newAmount / defaultAmount;

  @override
  void initState() {
    super.initState();
    defaultAmount = widget.recipe.serving.amount;
    newAmount = widget.recipe.serving.amount;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final useDesktop = FBreakpoint.gt(context, FBreakpoint.md);

        if (useDesktop) {
          return FRecipeDesktopLayout(
            recipe: widget.recipe,
            enableBookmark: widget.enableBookmark,
            enableBring: widget.enableBring,
            enableReview: widget.enableReview,
            readOnly: widget.readOnly,
            hasFab: widget.hasFab,
            showAllFiles: widget.showAllFiles,
            addToBring: widget.addToBring,
            addBookmark: widget.addBookmark,
            setRating: widget.setRating,

            nutrition: calculateNutrition(widget.recipe),
            amountFactor: amountFactor,
            newAmount: newAmount,
            decreaseServing: decreaseFactor,
            increaseServing: increaseFactor,
          );
        } else {
          return FRecipeMobileLayout(
            recipe: widget.recipe,
            enableBookmark: widget.enableBookmark,
            enableBring: widget.enableBring,
            enableReview: widget.enableReview,
            readOnly: widget.readOnly,
            hasFab: widget.hasFab,
            showAllFiles: widget.showAllFiles,
            addToBring: widget.addToBring,
            addBookmark: widget.addBookmark,
            setRating: widget.setRating,

            nutrition: calculateNutrition(widget.recipe),
            amountFactor: amountFactor,
            newAmount: newAmount,
            decreaseServing: decreaseFactor,
            increaseServing: increaseFactor,
          );
        }
      },
    );
  }

  CommonNutrition? calculateNutrition(CommonRecipe recipe) {
    final provider = ref.read(pRestUnitConversionsProvider.notifier);
    final nutrition = <CommonNutrition>[];
    for (var iG in recipe.ingredientGroups) {
      for (var i in iG.ingredients) {
        if (i.nutrition == null || !UDouble.isPositive(i.amount)) continue;

        var nutritionalValue = CommonNutrition.empty();

        if (i.unit == null || EString.isEmpty(i.nutrition!.openFoodFactsId)) {
          nutritionalValue = nutritionalValue.add(i.nutrition!);
        } else {
          // nutrition info is for 100g
          final conversionFactor =
              provider.convertFromGram(i.unit!.unitRef.id) ?? 1;

          // e.g.  100g = 80  kcal => 2kg = 1600 kcal
          //         1g = 0.8 kcal
          //
          // amount / conversionFactor = factor
          //    2kg / 0.001            = 2000
          //
          // kcal (per 1g) * factor = convertedNutrition
          // 0.8 kcal      * 2000   = 1600 kcal

          final factor = (i.amount! / conversionFactor);

          final convertedNutrition = i.nutrition!.multiply(0.01 * factor);

          nutritionalValue = nutritionalValue.add(convertedNutrition);
        }

        nutritionalValue = nutritionalValue.multiply(amountFactor);

        nutrition.add(nutritionalValue);
      }
    }

    final calculatedNutrition = nutrition.fold(
      CommonNutrition.empty(),
      (a, b) => a.add(b),
    );
    if (calculatedNutrition.exists) {
      return calculatedNutrition;
    } else {
      return null;
    }
  }

  void decreaseFactor() {
    if (newAmount > 1) setState(() => newAmount--);
  }

  void increaseFactor() {
    setState(() => newAmount++);
  }
}
