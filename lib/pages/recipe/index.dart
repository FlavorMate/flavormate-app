import 'package:flavormate/components/dialogs/t_confirm_dialog.dart';
import 'package:flavormate/components/dialogs/t_loading_dialog.dart';
import 'package:flavormate/components/recipe/dialogs/change_owner_dialog.dart';
import 'package:flavormate/components/recipe/dialogs/library_dialog.dart';
import 'package:flavormate/components/recipe/recipe_action_button.dart';
import 'package:flavormate/components/recipe/recipe_author.dart';
import 'package:flavormate/components/recipe/recipe_categories.dart';
import 'package:flavormate/components/recipe/recipe_informations.dart';
import 'package:flavormate/components/recipe/recipe_published.dart';
import 'package:flavormate/components/recipe/recipe_tags.dart';
import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/appLink/app_link.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/pages/recipe/variations/desktop.dart';
import 'package:flavormate/pages/recipe/variations/mobile.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/features/p_feature_bring.dart';
import 'package:flavormate/riverpod/highlights/p_highlight.dart';
import 'package:flavormate/riverpod/recipe_draft/p_recipe_drafts.dart';
import 'package:flavormate/riverpod/recipes/p_action_button.dart';
import 'package:flavormate/riverpod/recipes/p_latest_recipes.dart';
import 'package:flavormate/riverpod/recipes/p_recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/riverpod/stories/p_stories.dart';
import 'package:flavormate/riverpod/units/p_unit_conversions.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_app_link.dart';
import 'package:flavormate/utils/u_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends ConsumerStatefulWidget {
  final String id;
  final String? title;

  const RecipePage({required this.id, super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends ConsumerState<RecipePage> {
  late double servingFactor = -1;

  @override
  void initState() {
    super.initState();
    ref.listenManual(pRecipeProvider(int.parse(widget.id)), (_, next) {
      servingFactor = next.value!.serving.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pRecipeProvider(int.parse(widget.id)));
    final userProvider = ref.watch(pActionButtonProvider(int.parse(widget.id)));
    final bringProvider = ref.watch(pFeatureBringProvider);

    return RScaffold(
      provider,
      appBar: TAppBar(
        title: widget.title ?? L10n.of(context).p_recipe_title,
        actions: [
          IconButton(
            onPressed: () => share(context),
            icon: const Icon(MdiIcons.shareVariant),
          ),
          RStruct(
            userProvider,
            (_, user) => Visibility(
              visible: user.isAdmin || user.isOwner,
              child: ActionButton(
                recipeId: int.parse(widget.id),
                edit: () => edit(),
                delete: () => delete(),
                transfer: () => transfer(),
              ),
            ),
          ),
        ],
      ),
      builder: (_, recipe) => LayoutBuilder(
        builder: (_, constraints) {
          final useDesktop = Breakpoints.gt(context, Breakpoints.m);
          return RStruct(
            bringProvider,
            (context, isBringEnabled) {
              return TResponsive(
                maxWidth: useDesktop ? Breakpoints.l : constraints.maxWidth,
                child: TColumn(
                  children: [
                    if (useDesktop)
                      RecipePageDesktop(
                        recipe: recipe,
                        isBringEnabled: isBringEnabled,
                        servingFactor: servingFactor,
                        decreaseServing: decreaseFactor,
                        increaseServing: increaseFactor,
                        addBookmark: () => addToBook(recipe),
                        addToBring: () => addToBring(recipe),
                        nutrition: calculateNutrition(recipe),
                      ),
                    if (!useDesktop)
                      RecipePageMobile(
                        recipe: recipe,
                        isBringEnabled: isBringEnabled,
                        servingFactor: servingFactor,
                        decreaseServing: decreaseFactor,
                        increaseServing: increaseFactor,
                        addBookmark: () => addToBook(recipe),
                        addToBring: () => addToBring(recipe),
                        nutrition: calculateNutrition(recipe),
                      ),
                    const Divider(),
                    RecipeInformations(
                      course: recipe.course,
                      diet: recipe.diet,
                    ),
                    const Divider(),
                    RecipeCategories(categories: recipe.categories!),
                    const Divider(),
                    RecipeTags(tags: recipe.tags!),
                    const Divider(),
                    RecipeAuthor(author: recipe.author!),
                    const Divider(),
                    RecipePublished(
                      createdOn: recipe.createdOn!,
                      version: recipe.version!,
                      url: recipe.url,
                    )
                  ],
                ),
              );
            },
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
    final url = ref.read(pApiProvider).bringClient.get(
          ref.read(pServerProvider)!,
          recipe.id!,
          recipe.serving.amount.toInt(),
          servingFactor.toInt(),
        );
    if (!await launchUrl(Uri.parse(url))) {
      if (!mounted) return;
      context.showTextSnackBar(L10n.of(context).p_recipe_error_bring);
    }
  }

  Future<void> addToBook(Recipe recipe) async {
    await showDialog(
      context: context,
      builder: (_) => LibraryDialog(recipe: recipe),
    );
  }

  decreaseFactor() {
    if (servingFactor > 1) setState(() => servingFactor--);
  }

  increaseFactor() {
    setState(() => servingFactor++);
  }

  share(BuildContext context) async {
    final recipe = await ref.read(pRecipeProvider(int.parse(widget.id)).future);
    final token = await ref
        .read(pApiProvider)
        .tokenClient
        .create(data: {'id': recipe.id});

    if (!context.mounted) return;

    final server = ref.read(pServerProvider);

    final appLink = AppLink(
      server: server,
      page: 'recipe',
      id: recipe.id!,
      token: token.token,
    );

    final url = UAppLink.createURL(
      AppLinkMode.open,
      appLink,
    );

    await Share.share(
      '${L10n.of(context).p_recipe_share(recipe.label)} 🍽️\n$url',
    );
  }

  edit() async {
    showDialog(context: context, builder: (_) => const TLoadingDialog());

    final id =
        await ref.read(pRecipeDraftsProvider.notifier).recipeToDraft(widget.id);

    if (!mounted) return;
    context.pop();
    if (id == null) {
      context.showTextSnackBar(L10n.of(context).p_editor_edit_failed);
    } else {
      context.pushNamed('recipe-editor', pathParameters: {'id': '$id'});
    }
  }

  transfer() async {
    final id = await showDialog<int>(
        context: context, builder: (_) => const ChangeOwnerDialog());
    if (id == null) return;

    final response = await ref
        .read(pApiProvider)
        .recipesClient
        .changeOwner(int.parse(widget.id), {'owner': id});
    if (response) {
      ref.invalidate(pRecipeProvider(int.parse(widget.id)));

      if (!mounted) return;
      context.showTextSnackBar(L10n.of(context).d_recipe_change_owner_success);
    }
  }

  delete() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => TConfirmDialog(
        title: L10n.of(context).d_recipe_delete_title,
      ),
    );
    if (!response!) return;
    if (await ref
        .read(pApiProvider)
        .recipesClient
        .deleteById(int.parse(widget.id))) {
      ref.invalidate(pLatestRecipesProvider);
      ref.invalidate(pHighlightProvider);
      ref.invalidate(pStoriesProvider);

      if (!mounted) return;
      context.pushReplacementNamed('home');
      context.showTextSnackBar(L10n.of(context).d_recipe_delete_success);
    }
  }
}
