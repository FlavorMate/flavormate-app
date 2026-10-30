import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/constants/shape_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id_files.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_grid.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class RecipeEditorItemFilesPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemFilesPage({super.key, required this.draftId});

  String get pageProviderId => PageableState.recipeDraftFiles.getId(draftId);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemFilesPageState();
}

class _RecipeEditorItemFilesPageState
    extends ConsumerState<RecipeEditorItemFilesPage>
    with FOrderMixin<RecipeEditorItemFilesPage> {
  final _scrollController = ScrollController();

  PRestRecipeDraftsIdFilesProvider get provider =>
      pRestRecipeDraftsIdFilesProvider(
        pageProviderId: widget.pageProviderId,
        recipeDraftId: widget.draftId,
        orderBy: orderBy,
        orderDirection: orderDirection,
      );

  PRestRecipeDraftsIdFilesProvider get allProvider =>
      pRestRecipeDraftsIdFilesProvider(
        pageProviderId: widget.pageProviderId,
        recipeDraftId: widget.draftId,
        orderBy: orderBy,
        orderDirection: orderDirection,
        pageSize: -1,
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
        title: context.l10n.recipe_editor_item_files_page__title,
        actions: [
          FProgress(
            provider: provider,
            color: context.colorScheme.onSurface,
            optional: true,
            getProgress: (data) => data.data.isEmpty ? 0 : 1,
          ),
        ],
      ),
      floatingActionButton: M3EFab(
        size: .regular,
        onPressed: () => addImage(),
        icon: const Icon(Symbols.add_rounded),
      ),
      body: SafeArea(
        child: FProviderBuilder(
          provider: allProvider,
          onError: FEmptyMessage(
            title: context.l10n.recipe_editor_item_files_page__on_error,
            icon: IconConstants.errorIcon,
          ),
          onEmpty: FEmptyMessage(
            title: context.l10n.recipe_editor_item_files_page__on_empty,
            icon: IconConstants.emptyIcon,
          ),
          builder: (allFiles) {
            final allUrls = allFiles.data
                .map((it) => it.url(.Original))
                .toList();

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                FConstrainedBoxSliver(
                  maxWidth: FBreakpoint.mdValue,
                  padding: const .all(PADDING),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      FPageIntroductionSliver(
                        shape: ShapeConstants.editor,
                        icon: Symbols.photo_library_rounded,
                        description: context
                            .l10n
                            .recipe_editor_item_files_page__description,
                      ),

                      const FSizedBoxSliver(height: PADDING),

                      FLazySliverGrid(
                        key: null,
                        provider: provider,
                        pageProvider: widget.pageProvider,
                        rowHeight: FContentImageCard.HEIGHT,
                        itemBuilder:
                            (
                              item, {
                              required index,
                              required topLeft,
                              required topRight,
                              required bottomLeft,
                              required bottomRight,
                            }) => FContentImageCard(
                              key: ValueKey(item.id),
                              imageSelector: item.url,
                              onTap: () => context.showFullscreenImage(
                                urls: allUrls,
                                index: index,
                              ),
                              topLeft: topLeft,
                              topRight: topRight,
                              bottomLeft: bottomLeft,
                              bottomRight: bottomRight,
                              children: [
                                Positioned(
                                  top: PADDING / 2,
                                  right: PADDING / 2,
                                  child: M3EIconButton(
                                    variant: .standard,
                                    decoration: .new(
                                      backgroundColor: .all(
                                        context.colorScheme.primaryContainer,
                                      ),
                                    ),
                                    onPressed: () => deleteImage(item.id),
                                    icon: const Icon(Symbols.delete_rounded),
                                  ),
                                ),
                              ],
                            ),
                        scrollController: _scrollController,
                      ),
                    ],
                  ),
                ),
                const FSizedBoxSliver(height: PADDING),
                const FSizedBoxSliver(height: kFabHeight),
              ],
            );
          },
        ),
      ),
    );
  }

  void addImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null || !context.mounted) return;

    final fileLength = await image.length();
    final fileSize = fileLength / 1024 / 1024;

    if (!mounted) return;

    if (fileSize >= 10) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_item_files_page__file_add_too_large,
      );
      return;
    }

    context.showLoadingDialog(hint: true);

    final response = await ref.read(provider.notifier).addImage(image);

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_item_files_page__file_add_on_error,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_editor_item_files_page__file_add_on_success,
      );
    }
  }

  void deleteImage(
    String id,
  ) async {
    final result = await openConfirmDialog(
      context,
      title: context.l10n.recipe_editor_item_files_page__delete,
    );

    if (!mounted || result != true) return;
    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).deleteImage(id);

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_item_files_page__file_delete_on_error,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_editor_item_files_page__file_delete_on_success,
      );
    }
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.CreatedOn;
}
