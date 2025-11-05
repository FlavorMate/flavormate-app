import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id_files.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
  PRestRecipeDraftsIdFilesProvider get provider =>
      pRestRecipeDraftsIdFilesProvider(
        pageProviderId: widget.pageProviderId,
        recipeDraftId: widget.draftId,
        orderBy: orderBy,
        orderDirection: orderDirection,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).recipe_editor_item_files_page__title,
        actions: [
          FProgress(
            provider: provider,
            color: context.colorScheme.onSurface,
            optional: true,
            getProgress: (data) => data.data.isEmpty ? 0 : 1,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addImage(context, ref),
        child: const Icon(MdiIcons.plus),
      ),
      body: FPageable(
        provider: provider,
        pageProvider: widget.pageProvider,
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: OrderByConstants.files,
          padding: padding,
        ),
        builder: (_, data) => FWrap(
          children: [
            for (final image in data)
              Stack(
                children: [
                  FImageCard.maximized(
                    imageType: FImageType.secure,
                    coverSelector: (resolution) => image.url(resolution),
                    width: 400,
                    onTap: () => openFile(context, image),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      child: IconButton(
                        onPressed: () => deleteImage(context, ref, image.id),
                        icon: Icon(
                          MdiIcons.delete,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        onError: FEmptyMessage(
          title: L10n.of(context).recipe_editor_item_files_page__on_error,
          icon: StateIconConstants.files.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(context).recipe_editor_item_files_page__on_empty,
          icon: StateIconConstants.files.emptyIcon,
        ),
      ),
    );
  }

  void addImage(BuildContext context, WidgetRef ref) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null || !context.mounted) return;

    context.showLoadingDialog(hint:true);

    final response = await ref.read(provider.notifier).addImage(image);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_item_files_page__file_add_on_error,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_item_files_page__file_add_on_success,
      );
    }
  }

  void deleteImage(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(
          context,
        ).recipe_editor_item_files_page__delete,
      ),
    );

    if (!context.mounted || result != true) return;
    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).deleteImage(id);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_item_files_page__file_delete_on_error,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).recipe_editor_item_files_page__file_delete_on_success,
      );
    }
  }

  Future openFile(BuildContext context, RecipeDraftFileDto file) {
    return context.showFullscreenImage(file.url(ImageWideResolution.Original));
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.CreatedOn;
}
