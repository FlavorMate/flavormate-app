import 'package:flavormate/components/public_recipe/public_recipe_author.dart';
import 'package:flavormate/components/public_recipe/public_recipe_categories.dart';
import 'package:flavormate/components/public_recipe/public_recipe_tags.dart';
import 'package:flavormate/components/recipe/recipe_informations.dart';
import 'package:flavormate/components/recipe/recipe_published.dart';
import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/appLink/app_link.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/pages/public_recipe/variations/desktop.dart';
import 'package:flavormate/pages/public_recipe/variations/mobile.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/public_recipes/p_public_recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/riverpod/units/p_unit_conversions.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicRecipePage extends ConsumerStatefulWidget {
  final AppLink appLink;

  const PublicRecipePage({required this.appLink, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PublicRecipePageState();
}

class _PublicRecipePageState extends ConsumerState<PublicRecipePage> {
  late double servingFactor = -1;

  @override
  void initState() {
    super.initState();
    ref.listenManual(pPublicRecipeProvider(widget.appLink), (_, next) {
      if (!next.hasValue) return;
      servingFactor = next.value!.serving.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pPublicRecipeProvider(widget.appLink));
    return RScaffold(
      provider,
      appBar: TAppBar(title: L10n.of(context).p_recipe_title),
      errorBuilder: (_, _) => Scaffold(
        appBar: TAppBar(title: L10n.of(context).p_public_recipe_error_title),
        body: Center(
          child: TEmptyMessage(
            icon: MdiIcons.cloudQuestionOutline,
            title: L10n.of(context).p_public_recipe_error_label,
            subtitle: L10n.of(
              context,
            ).p_public_recipe_error_sublabel.replaceAll('\\n', '\n'),
          ),
        ),
      ),
      builder: (_, recipe) => LayoutBuilder(
        builder: (_, constraints) {
          final useDesktop = Breakpoints.gt(context, Breakpoints.m);
          return TResponsive(
            maxWidth: useDesktop ? Breakpoints.l : constraints.maxWidth,
            child: TColumn(
              children: [
                if (useDesktop)
                  PublicRecipePageDesktop(
                    recipe: recipe,
                    servingFactor: servingFactor,
                    decreaseServing: decreaseFactor,
                    increaseServing: increaseFactor,
                    addToBring: () => addToBring(recipe),
                    nutrition: calculateNutrition(recipe),
                  ),
                if (!useDesktop)
                  PublicRecipePageMobile(
                    recipe: recipe,
                    servingFactor: servingFactor,
                    decreaseServing: decreaseFactor,
                    increaseServing: increaseFactor,
                    addToBring: () => addToBring(recipe),
                    nutrition: calculateNutrition(recipe),
                  ),
                const Divider(),
                RecipeInformations(course: recipe.course, diet: recipe.diet),
                const Divider(),
                PublicRecipeCategories(categories: recipe.categories!),
                const Divider(),
                PublicRecipeTags(tags: recipe.tags!),
                const Divider(),
                PublicRecipeAuthor(author: recipe.author!),
                const Divider(),
                RecipePublished(
                  createdOn: recipe.createdOn!,
                  version: recipe.version!,
                  url: recipe.url,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Nutrition? calculateNutrition(Recipe recipe) {
    final provider = ref.read(pUnitConversionProvider.notifier);
    final nutrition = <Nutrition>[];
    for (var iG in recipe.ingredientGroups) {
      for (var i in iG.ingredients) {
        if (i.nutrition == null || !UDouble.isPositive(i.amount)) continue;

        var nutritionalValue = Nutrition();

        if (i.unitLocalized == null ||
            EString.isEmpty(i.nutrition!.openFoodFactsId)) {
          nutritionalValue = nutritionalValue.add(i.nutrition!);
        } else {
          // nutrition info is for 100g
          final conversionFactor =
              provider.convertFromGram(i.unitLocalized!.unitRef) ?? 1;

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

        final servingAdjustmentFactor = servingFactor / recipe.serving.amount;

        nutritionalValue = nutritionalValue.multiply(servingAdjustmentFactor);

        nutrition.add(nutritionalValue);
      }
    }

    final calculatedNutrition = nutrition.fold(Nutrition(), (a, b) => a.add(b));
    if (calculatedNutrition.exists) {
      return calculatedNutrition;
    } else {
      return null;
    }
  }

  Future<void> addToBring(Recipe recipe) async {
    final server = ref.read(pServerProvider);
    final url = await ref
        .read(pApiProvider)
        .bringClient
        .post(
          server,
          recipe.id!,
          recipe.serving.amount.toInt(),
          servingFactor.toInt(),
        );

    if (!await launchUrl(Uri.parse(url))) {
      if (!mounted) return;
      context.showTextSnackBar(L10n.of(context).p_recipe_error_bring);
    }
  }

  void decreaseFactor() {
    if (servingFactor > 1) setState(() => servingFactor--);
  }

  void increaseFactor() {
    setState(() => servingFactor++);
  }
}
