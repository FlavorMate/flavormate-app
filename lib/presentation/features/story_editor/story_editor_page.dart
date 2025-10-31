import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_data_table.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryEditorPage extends ConsumerWidget {
  const StoryEditorPage({super.key});

  PRestStoryDraftsProvider get provider =>
      pRestStoryDraftsProvider(PageableState.storyDrafts.name);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.storyDrafts.name);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).story_editor_page__title),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createDraft(context, ref),
        child: const Icon(MdiIcons.plus),
      ),
      body: FPageable(
        provider: provider,
        pageProvider: pageProvider,
        padding: 0,
        builder: (_, data) => FDataTable(
          columns: [
            FDataColumn(
              alignment: Alignment.centerLeft,
              child: Text(L10n.of(context).story_editor_page__table_label),
            ),
            FDataColumn(
              width: 72,
              alignment: Alignment.centerLeft,
              child: Text(L10n.of(context).story_editor_page__table_state),
            ),
            FDataColumn(width: 48),
          ],
          rows: [
            for (final draft in data)
              FDataRow(
                onSelectChanged: (value) => openDraft(context, value, draft.id),
                cells: [
                  Text(
                    draft.label?.shorten() ??
                        L10n.of(context).story_editor_page__table_undefined,
                  ),
                  Text(
                    draft.isNew
                        ? L10n.of(context).story_editor_page__table_new
                        : L10n.of(context).story_editor_page__table_update,
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
          title: L10n.of(context).story_editor_page__on_error,
          icon: StateIconConstants.drafts.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(context).story_editor_page__on_empty,
          icon: StateIconConstants.drafts.emptyIcon,
        ),
      ),
    );
  }

  Future<void> createDraft(BuildContext context, WidgetRef ref) async {
    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).createDraft();

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).story_editor_page__create_error,
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
        title: L10n.of(context).story_editor_page__delete_draft,
      ),
    );

    if (!context.mounted || confirmation != true) return;

    context.showLoadingDialog();

    await ref.read(provider.notifier).deleteDraft(id);

    if (!context.mounted) return;
    context.pop();
  }

  void openDraft(BuildContext context, bool? value, String id) {
    if (value != true) return;

    if (!context.mounted) return;
    context.routes.storyEditorItem(id);
  }
}
