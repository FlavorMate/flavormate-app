import 'package:flavormate/core/config/features/p_feature_ratings.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/repositories/extension/bring/p_bring.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/features/recipes_item/dialogs/recipes_item_change_owner_dialog.dart';
import 'package:flavormate/presentation/features/recipes_item/dialogs/recipes_item_save_in_book_dialog.dart';
import 'package:flavormate/presentation/features/recipes_item/providers/p_recipes_item_page.dart';
import 'package:flavormate/presentation/features/recipes_item/widgets/recipes_item_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipesItemPage extends ConsumerStatefulWidget {
  final String id;

  const RecipesItemPage({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecipePageState();

  PRecipesItemPageProvider get provider => pRecipesItemPageProvider(id);
}

class _RecipePageState extends ConsumerState<RecipesItemPage> {
  double defaultAmount = -1;
  double newAmount = -1;

  double get amountFactor => newAmount / defaultAmount;

  @override
  void initState() {
    super.initState();
    URiverpod.listenManual(ref, widget.provider, (data) {
      defaultAmount = data.recipe.serving.amount;
      newAmount = data.recipe.serving.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratingsEnabled = ref.watch(pFeatureRatingsProvider);

    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(
        title: data.recipe.label,
        actions: [
          if (data.isShareEnabled)
            IconButton(
              onPressed: () => share(data.recipe),
              icon: const Icon(MdiIcons.shareVariant),
            ),
          if (data.isOwner || data.isAdmin)
            RecipesItemActionButton(
              isAdmin: data.isAdmin,
              isOwner: data.isOwner,
              edit: edit,
              delete: delete,
              transfer: transfer,
            ),
        ],
      ),
      builder: (context, data) => FRecipe(
        recipe: data.recipe,
        enableBookmark: true,
        enableBring: data.isBringEnabled,
        enableReview: ratingsEnabled,
        addToBring: addToBring,
        addBookmark: () => addToBook(data.recipe),
        setRating: (val) => setRating(val),
        showAllFiles: () => context.routes.recipesItemFiles(data.recipe.id),
        readOnly: false,
      ),
      onError: FEmptyMessage(
        title: context.l10n.recipes_item_page__on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
    );
  }

  Future<void> addToBring() async {
    context.showLoadingDialog();

    final uri = await ref.read(pBringProvider(widget.id).future);

    if (!mounted) return;
    context.pop();

    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      context.showTextSnackBar(
        context.l10n.recipes_item_page__bring_on_error,
      );
    }
  }

  Future<void> addToBook(CommonRecipe recipe) async {
    await showDialog(
      context: context,
      builder: (_) => RecipesItemSaveInBookDialog(recipe: recipe),
    );
  }

  Future<void> setRating(double? val) async {
    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).setRating(val);

    if (!mounted) return;
    context.pop();

    print(response);
  }

  void decreaseFactor() {
    if (newAmount > 1) setState(() => newAmount--);
  }

  void increaseFactor() {
    setState(() => newAmount++);
  }

  Future<void> share(CommonRecipe recipe) async {
    context.showLoadingDialog();

    final url = await ref.read(widget.provider.notifier).shareRecipe();

    if (!mounted) return;
    context.pop();

    if (url.hasError) {
      context.showTextSnackBar("Couldn't share recipe");
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        text:
            '${context.l10n.recipes_item_page__share_text(recipe.label)}\n${url.data!}',
      ),
    );
  }

  Future<void> edit() async {
    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).editRecipe();

    if (!mounted) return;
    context.pop();

    if (response.hasError || !response.hasData) {
      context.showTextSnackBar(
        context.l10n.recipes_item_page__edit_on_error,
      );
    } else {
      context.routes.recipeEditorItem(response.data!);
    }
  }

  Future<void> transfer() async {
    final account = await showDialog<String>(
      context: context,
      builder: (_) => const RecipesItemChangeOwnerDialog(),
    );
    if (account == null) return;

    final response = await ref
        .read(widget.provider.notifier)
        .transferRecipe(widget.id, account);

    if (!mounted) return;

    if (!response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipes_item_page__transfer_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipes_item_page__transfer_error,
      );
    }
  }

  Future<void> delete() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context.l10n.recipes_item_page__delete_title,
      ),
    );
    if (response != true) return;

    final result = await ref.read(widget.provider.notifier).delete();

    if (result.hasError || result.data != true) {
      if (!mounted) return;
      context.showTextSnackBar(
        context.l10n.recipes_item_page__delete_failure,
      );
    } else {
      if (!mounted) return;
      context.showTextSnackBar(
        context.l10n.recipes_item_page__delete_success,
      );
      await context.routes.home(replace: true);
    }
  }
}
