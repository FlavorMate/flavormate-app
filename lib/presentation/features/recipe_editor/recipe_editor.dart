import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_data_table.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/features/recipe_editor/dialogs/recipe_editor_scrape_dialog.dart';
import 'package:flavormate/presentation/features/recipe_editor/widgets/recipe_editor_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorPage extends ConsumerWidget {
  const RecipeEditorPage({super.key});

  PRestRecipeDraftsProvider get provider =>
      pRestRecipeDraftsProvider(PageableState.recipeDrafts.name);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.recipeDrafts.name);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).recipe_editor_page__title),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: RecipeEditorFab(
        onCreate: () => createDraft(context, ref),
        onScrape: () => scrapeDraft(context, ref),
      ),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: pageProvider,
          padding: 0,
          builder: (_, data) => FDataTable(
            columns: [
              FDataColumn(
                alignment: Alignment.centerLeft,
                child: Text(L10n.of(context).recipe_editor_page__table_label),
              ),
              FDataColumn(
                width: 72,
                alignment: Alignment.centerLeft,
                child: Text(L10n.of(context).recipe_editor_page__table_state),
              ),
              FDataColumn(width: 48),
            ],
            rows: [
              for (final draft in data)
                FDataRow(
                  onSelectChanged: (value) =>
                      openDraft(context, value, draft.id),
                  cells: [
                    Text(
                      draft.label?.shorten(length: 40) ??
                          L10n.of(context).recipe_editor_page__table_undefined,
                    ),
                    Text(
                      draft.isNew
                          ? L10n.of(context).recipe_editor_page__table_new
                          : L10n.of(context).recipe_editor_page__table_update,
                    ),
                    IconButton(
                      icon: Icon(
                        MdiIcons.delete,
                        color: context.blendedColors.error,
                      ),
                      onPressed: () => deleteDraft(context, ref, draft.id),
                    ),
                  ],
                ),
            ],
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).recipe_editor_page__on_error,
            icon: StateIconConstants.drafts.errorIcon,
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).recipe_editor_page__on_empty,
            icon: StateIconConstants.drafts.emptyIcon,
          ),
        ),
      ),
    );
  }

  Future<void> createDraft(BuildContext context, WidgetRef ref) async {
    final response = await ref.read(provider.notifier).createDraft();

    if (!context.mounted) return;

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_page__create_error,
      );
    } else {
      openDraft(context, true, response.data!);
    }
  }

  Future<void> deleteDraft(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(context).recipe_editor_page__delete_draft,
      ),
    );

    if (!context.mounted || confirmation != true) return;

    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).deleteDraft(id);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_page__delete_error,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_page__delete_success,
      );
    }
  }

  void openDraft(BuildContext context, bool? value, String id) {
    if (value != true) return;

    context.routes.recipeEditorItem(id);
  }

  void scrapeDraft(BuildContext context, WidgetRef ref) async {
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
        L10n.of(context).recipe_editor_page__import_failure,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_page__import_success,
      );
      openDraft(context, true, response.data!);
    }
  }
}
