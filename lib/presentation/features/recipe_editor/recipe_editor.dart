import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_2d_table.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_lazy_table.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/features/recipe_editor/dialogs/recipe_editor_scrape_dialog.dart';
import 'package:flavormate/presentation/features/recipe_editor/widgets/recipe_editor_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorPage extends ConsumerStatefulWidget {
  const RecipeEditorPage({super.key});

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);

  static String get pageKey => PageableState.recipeDrafts.name;

  @override
  ConsumerState<RecipeEditorPage> createState() => _RecipeEditorPageState();
}

class _RecipeEditorPageState extends ConsumerState<RecipeEditorPage>
    with FOrderMixin {
  final ScrollController _scrollController = ScrollController();

  PRestRecipeDraftsProvider get provider => pRestRecipeDraftsProvider(
    RecipeEditorPage.pageKey,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.recipe_editor_page__title,
        scrollController: _scrollController,
      ),
      floatingActionButton: RecipeEditorFab(
        onCreate: () => createDraft(context),
        onScrape: () => scrapeDraft(context),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.recipe_editor_page__on_empty,
            icon: StateIconConstants.drafts.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.recipe_editor_page__on_error,
            icon: StateIconConstants.drafts.errorIcon,
          ),
          child: FLazyTable<RecipeDraftPreviewDto>(
            key: orderKey,
            provider: provider,
            pageProvider: widget.pageProvider,
            scrollController: _scrollController,
            rowHeight: 64,
            columns: [
              FExpressiveTableColumn(
                flex: 1,
                minWidth: 64,
                header: Text(context.l10n.recipe_editor_page__table_label),
                cellBuilder: (context, item, rowIndex) => Text(
                  item.label ??
                      context.l10n.recipe_editor_page__table_undefined,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 160,
                header: Text(context.l10n.recipe_editor_page__table_state),
                cellBuilder: (context, item, rowIndex) => Text(
                  item.isNew
                      ? context.l10n.recipe_editor_page__table_new
                      : context.l10n.recipe_editor_page__table_update,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 80,
                enableRowTap: false,
                alignment: Alignment.center,
                header: const SizedBox.shrink(),
                cellBuilder: (context, item, rowIndex) => IconButton(
                  onPressed: () => deleteDraft(context, item.id),
                  color: context.blendedColors.error,
                  icon: const Icon(MdiIcons.delete),
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).deleteButtonTooltip,
                ),
              ),
            ],
            onRowTap: (index, item) => openDraft(context, true, item.id),
          ),
        ),
      ),
    );
  }

  Future<void> createDraft(BuildContext context) async {
    final response = await ref.read(provider.notifier).createDraft();

    if (!context.mounted) return;

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__create_error,
      );
    } else {
      resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
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

    final response = await ref.read(provider.notifier).deleteDraft(id);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__delete_error,
      );
    } else {
      resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
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

    final response = await ref.read(provider.notifier).scrape(result);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__import_failure,
      );
    } else {
      resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__import_success,
      );
      openDraft(context, true, response.data!);
    }
  }

  @override
  OrderBy get defaultOrderBy => .CreatedOn;
}
