import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_2d_table.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_lazy_table.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryEditorPage extends ConsumerStatefulWidget {
  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);

  static String get pageKey => PageableState.storyDrafts.name;

  const StoryEditorPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoryEditorPageState();
}

class _StoryEditorPageState extends ConsumerState<StoryEditorPage>
    with FOrderMixin {
  final ScrollController _scrollController = ScrollController();

  PRestStoryDraftsProvider get provider => pRestStoryDraftsProvider(
    StoryEditorPage.pageKey,
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
        title: context.l10n.story_editor_page__title,
        scrollController: _scrollController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createDraft(context),
        child: const Icon(MdiIcons.plus),
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.story_editor_page__on_empty,
            icon: StateIconConstants.drafts.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.story_editor_page__on_error,
            icon: StateIconConstants.drafts.errorIcon,
          ),
          child: FLazyTable<StoryDraftDto>(
            key: orderKey,
            provider: provider,
            pageProvider: widget.pageProvider,
            scrollController: _scrollController,
            rowHeight: 64,
            columns: [
              FExpressiveTableColumn(
                flex: 1,
                minWidth: 64,
                header: Text(context.l10n.story_editor_page__table_label),
                cellBuilder: (context, item, rowIndex) => Text(
                  item.label ?? context.l10n.story_editor_page__table_undefined,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 160,
                header: Text(context.l10n.story_editor_page__table_state),
                cellBuilder: (context, item, rowIndex) => Text(
                  item.isNew
                      ? context.l10n.story_editor_page__table_new
                      : context.l10n.story_editor_page__table_update,
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
    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).createDraft();

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

    await ref.read(provider.notifier).deleteDraft(id);

    if (!context.mounted) return;
    context.pop();
  }

  void openDraft(BuildContext context, bool? value, String id) {
    if (value != true) return;

    if (!context.mounted) return;
    context.routes.storyEditorItem(id);
  }

  @override
  OrderBy get defaultOrderBy => .CreatedOn;
}
