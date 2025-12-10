import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/contents/f_paginated_content_table.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/widgets/f_data_table.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/features/recipe_editor/dialogs/recipe_editor_scrape_dialog.dart';
import 'package:flavormate/presentation/features/recipe_editor/widgets/recipe_editor_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorPage extends ConsumerStatefulWidget {
  const RecipeEditorPage({super.key});

  PRestRecipeDraftsProvider get provider =>
      pRestRecipeDraftsProvider(PageableState.recipeDrafts.name);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.recipeDrafts.name);

  @override
  ConsumerState<RecipeEditorPage> createState() => _RecipeEditorPageState();
}

class _RecipeEditorPageState extends ConsumerState<RecipeEditorPage> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: context.l10n.recipe_editor_page__title,
      provider: widget.provider,
      pageProvider: widget.pageProvider,
      onEmpty: FEmptyMessage(
        title: context.l10n.recipe_editor_page__on_empty,
        icon: StateIconConstants.drafts.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: context.l10n.recipe_editor_page__on_error,
        icon: StateIconConstants.drafts.errorIcon,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: RecipeEditorFab(
        onCreate: () => createDraft(context),
        onScrape: () => scrapeDraft(context),
      ),
      itemBuilder: (items) => FPaginatedContentTable(
        data: items,
        columnBuilder: [
          FDataColumn(
            alignment: Alignment.centerLeft,
            child: Text(context.l10n.recipe_editor_page__table_label),
          ),
          FDataColumn(
            width: 72,
            alignment: Alignment.centerLeft,
            child: Text(context.l10n.recipe_editor_page__table_state),
          ),
          FDataColumn(width: 48),
        ],
        rowBuilder: (item) => FDataRow(
          onSelectChanged: (value) => openDraft(context, value, item.id),
          cells: [
            Text(
              item.label?.shorten(length: 40) ??
                  context.l10n.recipe_editor_page__table_undefined,
            ),
            Text(
              item.isNew
                  ? context.l10n.recipe_editor_page__table_new
                  : context.l10n.recipe_editor_page__table_update,
            ),
            IconButton(
              icon: Icon(
                MdiIcons.delete,
                color: context.blendedColors.error,
              ),
              onPressed: () => deleteDraft(context, item.id),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createDraft(BuildContext context) async {
    final response = await ref.read(widget.provider.notifier).createDraft();

    if (!context.mounted) return;

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__create_error,
      );
    } else {
      openDraft(context, true, response.data!);
    }
  }

  Future<void> deleteDraft(
    BuildContext context,
    String id,
  ) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context.l10n.recipe_editor_page__delete_draft,
      ),
    );

    if (!context.mounted || confirmation != true) return;

    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).deleteDraft(id);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__delete_error,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__delete_success,
      );
    }
  }

  void openDraft(BuildContext context, bool? value, String id) {
    if (value != true) return;

    context.routes.recipeEditorItem(id);
  }

  void scrapeDraft(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => const RecipeEditorScrapeDialog(),
    );

    if (!context.mounted || result == null) return;

    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).scrape(result);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__import_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__import_success,
      );
      openDraft(context, true, response.data!);
    }
  }
}
