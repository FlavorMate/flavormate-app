import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id_files.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            icon: StateIconConstants.files.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.recipe_editor_item_preview_files_page__on_error,
            icon: StateIconConstants.files.errorIcon,
          ),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              FConstrainedBoxSliver(
                maxWidth: FBreakpoint.smValue,
                padding: const .all(PADDING),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    FLazySliverList(
                      key: null,
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _scrollController,
                      itemBuilder: (item, index, first, last) {
                        return FContentImageCard(
                          first: first,
                          last: last,
                          imageSelector: item.url,
                          onTap: () =>
                              context.showFullscreenImage(item.url(.Original)),
                        );
                      },
                    ),
                    // FPageable(
                    //   provider: provider,
                    //   pageProvider: widget.pageProvider,
                    //   builder: (_, data) => FWrap(
                    //     children: [
                    //       for (final image in data)
                    //         FImageCard.maximized(
                    //           coverSelector: (resolution) =>
                    //               image.url(resolution),
                    //           width: 400,
                    //           onTap: () => openFile(context, image),
                    //         ),
                    //     ],
                    //   ),
                    //   onEmpty: FEmptyMessage(
                    //     title: context
                    //         .l10n
                    //         .recipe_editor_item_preview_files_page__on_empty,
                    //     icon: StateIconConstants.files.emptyIcon,
                    //   ),
                    //   onError: FEmptyMessage(
                    //     title: context
                    //         .l10n
                    //         .recipe_editor_item_preview_files_page__on_error,
                    //     icon: StateIconConstants.files.errorIcon,
                    //   ),
                    // ),
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
