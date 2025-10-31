import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_preview/providers/p_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemPreviewPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemPreviewPage({required this.draftId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorPreviewPageState();

  PRecipeEditorPreviewPageProvider get provider =>
      pRecipeEditorPreviewPageProvider(draftId);
}

class _RecipeEditorPreviewPageState
    extends ConsumerState<RecipeEditorItemPreviewPage> {
  double defaultAmount = -1;
  double newAmount = -1;

  double get amountFactor => newAmount / defaultAmount;

  @override
  void initState() {
    super.initState();
    URiverpod.listenManual(ref, widget.provider, (data) {
      defaultAmount = data.serving.amount;
      newAmount = data.serving.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, _) => FAppBar(
        title: L10n.of(context).recipe_editor_item_preview_page__title,
      ),
      floatingActionButtonBuilder: (_, _) => FloatingActionButton(
        onPressed: uploadRecipe,
        child: const Icon(MdiIcons.upload),
      ),
      builder: (context, data) => FRecipe(
        recipe: data,
        enableBookmark: false,
        enableBring: false,
        readOnly: true,
        hasFab: true,
        showAllFiles: () =>
            context.routes.recipeEditorItemPreviewFiles(data.id),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).recipe_editor_item_preview_page__on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
    );
  }

  void uploadRecipe() async {
    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).upload();

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_item_preview_page__upload_failure,
      );
    } else {
      context.routes.home(replace: true);
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_item_preview_page__upload_success,
      );
    }
  }
}
