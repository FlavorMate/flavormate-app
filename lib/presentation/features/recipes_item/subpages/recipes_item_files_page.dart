import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_id_files.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesItemFilesPage extends ConsumerStatefulWidget {
  final String id;

  const RecipesItemFilesPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipesItemFilesPageState();

  String get pageKey => PageableState.recipeFiles.getId(id);

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);
}

class _RecipesItemFilesPageState extends ConsumerState<RecipesItemFilesPage> {
  PRestRecipesIdFilesProvider get provider => pRestRecipesIdFilesProvider(
    recipeId: widget.id,
    pageProviderId: widget.pageKey,
  );

  final _scrollController = ScrollController();

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
        title: context.l10n.recipes_item_files_page__title,
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.recipes_item_files_page__on_empty,
            icon: StateIconConstants.files.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.recipes_item_files_page__on_error,
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
                    FPageIntroductionSliver(
                      shape: .sunny,
                      icon: MdiIcons.imageMultiple,
                      description:
                          context.l10n.recipes_item_files_page__description,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FLazySliverList(
                      key: null,
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _scrollController,
                      itemBuilder: (item, index, first, last) {
                        return FContentImageCard(
                          imageSelector: item.url,
                          onTap: () => openFile(item),
                          first: first,
                          last: last,
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

  Future openFile(RecipeFileDto file) {
    return context.showFullscreenImage(file.url(ImageResolution.Original));
  }
}
