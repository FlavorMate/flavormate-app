import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id_files.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemPreviewFilesPage extends ConsumerWidget {
  final String draftId;

  const RecipeEditorItemPreviewFilesPage({super.key, required this.draftId});

  String get pageProviderId => PageableState.recipeDraftFiles.getId(draftId);

  PRestRecipeDraftsIdFilesProvider get provider =>
      pRestRecipeDraftsIdFilesProvider(
        recipeDraftId: draftId,
        pageProviderId: pageProviderId,
      );

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).recipe_editor_item_preview_files_page__title,
      ),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: pageProvider,
          builder: (_, data) => FWrap(
            children: [
              for (final image in data)
                FImageCard.maximized(
                  coverSelector: (resolution) => image.url(resolution),
                  width: 400,
                  onTap: () => openFile(context, image),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(
              context,
            ).recipe_editor_item_preview_files_page__on_empty,
            icon: StateIconConstants.files.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(
              context,
            ).recipe_editor_item_preview_files_page__on_error,
            icon: StateIconConstants.files.errorIcon,
          ),
        ),
      ),
    );
  }

  Future openFile(BuildContext context, RecipeDraftFileDto file) {
    return context.showFullscreenImage(file.url(ImageWideResolution.Original));
  }
}
