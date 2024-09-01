import 'package:flavormate/components/dialogs/confirm_dialog.dart';
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
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/pages/recipe/variations/desktop.dart';
import 'package:flavormate/pages/recipe/variations/mobile.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/highlights/p_highlight.dart';
import 'package:flavormate/riverpod/recipes/p_action_button.dart';
import 'package:flavormate/riverpod/recipes/p_latest_recipes.dart';
import 'package:flavormate/riverpod/recipes/p_recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/riverpod/stories/p_stories.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return RScaffold(
      provider,
      appBar: TAppBar(
        title: widget.title ?? L10n.of(context).p_recipe_title,
        actions: [
          // TODO: implement proper url handling
          // IconButton(
          //   onPressed: () => share(context),
          //   icon: const Icon(MdiIcons.shareVariant),
          // ),
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
          return TResponsive(
            maxWidth: useDesktop ? Breakpoints.l : constraints.maxWidth,
            child: TColumn(
              children: [
                if (useDesktop)
                  RecipePageDesktop(
                    recipe: recipe,
                    servingFactor: servingFactor,
                    decreaseServing: decreaseFactor,
                    increaseServing: increaseFactor,
                    addBookmark: () => addToBook(recipe),
                    addToBring: () => addToBring(recipe),
                  ),
                if (!useDesktop)
                  RecipePageMobile(
                    recipe: recipe,
                    servingFactor: servingFactor,
                    decreaseServing: decreaseFactor,
                    increaseServing: increaseFactor,
                    addBookmark: () => addToBook(recipe),
                    addToBring: () => addToBring(recipe),
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
      ),
    );
  }

  Future<void> addToBring(Recipe recipe) async {
    final url = ref.read(pApiProvider).recipesClient.bring(
          ref.read(pServerProvider)!,
          recipe.id!,
          recipe.serving.amount.toInt(),
          servingFactor.toInt(),
        );
    if (!await launchUrl(Uri.parse(url))) {
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
    // TODO: implement proper url handling
    // final recipe = await ref.read(pRecipeProvider(int.parse(widget.id)).future);
    // final url = '$frontendURL/recipe/${recipe.id}';
    // await Share.share(
    //   '${L10n.of(context).p_recipe_share(recipe.label)} 🍽️\n$url',
    // );
  }

  edit() async {
    final recipe = await ref.read(pRecipeProvider(int.parse(widget.id)).future);
  }

  transfer() async {
    final id = await showDialog<int>(
        context: context, builder: (_) => ChangeOwnerDialog());
    if (id == null) return;

    final response = await ref
        .read(pApiProvider)
        .recipesClient
        .changeOwner(int.parse(widget.id), {'owner': id});
    if (response) {
      ref.invalidate(pRecipeProvider(int.parse(widget.id)));
      context.showTextSnackBar(L10n.of(context).d_recipe_change_owner_success);
    }
  }

  delete() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
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
      context.pushReplacementNamed('home');
      context.showTextSnackBar(L10n.of(context).d_recipe_delete_success);
    }
  }
}
