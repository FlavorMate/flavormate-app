import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/contents/f_paginated_content_table.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/widgets/f_data_table.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryEditorPage extends ConsumerStatefulWidget {
  PRestStoryDraftsProvider get provider =>
      pRestStoryDraftsProvider(PageableState.storyDrafts.name);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.storyDrafts.name);
  const StoryEditorPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoryEditorPageState();
}

class _StoryEditorPageState extends ConsumerState<StoryEditorPage> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: context.l10n.story_editor_page__title,
      provider: widget.provider,
      pageProvider: widget.pageProvider,
      onEmpty: FEmptyMessage(
        title: context.l10n.story_editor_page__on_empty,
        icon: StateIconConstants.drafts.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: context.l10n.story_editor_page__on_error,
        icon: StateIconConstants.drafts.errorIcon,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createDraft(context),
        child: const Icon(MdiIcons.plus),
      ),
      itemBuilder: (items) => FPaginatedContentTable(
        data: items,
        columnBuilder: [
          FDataColumn(
            alignment: Alignment.centerLeft,
            child: Text(context.l10n.story_editor_page__table_label),
          ),
          FDataColumn(
            width: 72,
            alignment: Alignment.centerLeft,
            child: Text(context.l10n.story_editor_page__table_state),
          ),
          FDataColumn(width: 48),
        ],
        rowBuilder: (item) => FDataRow(
          onSelectChanged: (value) => openDraft(context, value, item.id),
          cells: [
            Text(
              item.label?.shorten() ??
                  context.l10n.story_editor_page__table_undefined,
            ),
            Text(
              item.isNew
                  ? context.l10n.story_editor_page__table_new
                  : context.l10n.story_editor_page__table_update,
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
    context.showLoadingDialog();

    final response = await ref.read(widget.provider.notifier).createDraft();

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.story_editor_page__create_error,
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
        title: context.l10n.story_editor_page__delete_draft,
      ),
    );

    if (!context.mounted || confirmation != true) return;

    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).deleteDraft(id);

    if (!context.mounted) return;
    context.pop();
  }

  void openDraft(BuildContext context, bool? value, String id) {
    if (value != true) return;

    if (!context.mounted) return;
    context.routes.storyEditorItem(id);
  }
}
