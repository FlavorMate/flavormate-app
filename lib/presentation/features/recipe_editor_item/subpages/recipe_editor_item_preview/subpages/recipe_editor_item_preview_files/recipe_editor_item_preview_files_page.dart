import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id_files.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_grid.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class RecipeEditorItemPreviewFilesPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemPreviewFilesPage({super.key, required this.draftId});

  String get pageKey => PageableState.recipeDraftFiles.getId(draftId);

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemPreviewFilesPageState();
}

class _RecipeEditorItemPreviewFilesPageState
    extends ConsumerState<RecipeEditorItemPreviewFilesPage> {
  final _scrollController = ScrollController();

  PRestRecipeDraftsIdFilesProvider get provider =>
      pRestRecipeDraftsIdFilesProvider(
        recipeDraftId: widget.draftId,
        pageProviderId: widget.pageKey,
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
        scrollController: _scrollController,
        title: context.l10n.recipe_editor_item_preview_files_page__title,
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.recipe_editor_item_preview_files_page__on_empty,
            icon: IconConstants.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.recipe_editor_item_preview_files_page__on_error,
            icon: IconConstants.errorIcon,
          ),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              FConstrainedBoxSliver(
                maxWidth: FBreakpoint.smValue,
                padding: const .all(PADDING),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    FLazySliverGrid(
                      key: null,
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _scrollController,
                      rowHeight: FContentImageCard.HEIGHT,
                      itemBuilder:
                          (
                            item, {
                            required index,
                            required topLeft,
                            required topRight,
                            required bottomLeft,
                            required bottomRight,
                          }) {
                            return FContentImageCard(
                              imageSelector: item.url,
                              onTap: () => context.showFullscreenImage(
                                item.url(.Original),
                              ),
                              topLeft: topLeft,
                              topRight: topRight,
                              bottomLeft: bottomLeft,
                              bottomRight: bottomRight,
                            );
                          },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openFile(BuildContext context, RecipeDraftFileDto file) {
    return context.showFullscreenImage(file.url(ImageResolution.Original));
  }
}
