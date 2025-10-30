import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_id_files.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesItemFilesPage extends ConsumerWidget {
  final String id;

  const RecipesItemFilesPage({super.key, required this.id});

  String get pageProviderId => PageableState.recipeFiles.getId(id);

  PRestRecipesIdFilesProvider get provider =>
      pRestRecipesIdFilesProvider(recipeId: id, pageProviderId: pageProviderId);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).recipes_item_files_page__titletitle,
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
            title: L10n.of(context).recipes_item_files_page__titleon_empty,
            icon: StateIconConstants.files.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).recipes_item_files_page__titleon_error,
            icon: StateIconConstants.files.errorIcon,
          ),
        ),
      ),
    );
  }

  Future openFile(BuildContext context, RecipeFileDto file) {
    return context.showFullscreenImage(file.url(ImageWideResolution.Original));
  }
}
