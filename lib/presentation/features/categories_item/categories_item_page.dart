import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/categories/p_rest_categories_id.dart';
import 'package:flavormate/data/repositories/features/categories/p_rest_categories_id_recipes.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_side_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesItemPage extends ConsumerStatefulWidget {
  final String id;

  const CategoriesItemPage({required this.id, super.key});

  String get pageKey => PageableState.categoryRecipes.getId(id);

  PRestCategoriesIdProvider get provider => pRestCategoriesIdProvider(id);

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);

  @override
  ConsumerState<CategoriesItemPage> createState() => _CategoriesItemPageState();
}

class _CategoriesItemPageState extends ConsumerState<CategoriesItemPage>
    with FOrderMixin<CategoriesItemPage> {
  final _scrollController = ScrollController();

  PRestCategoriesIdRecipesProvider get recipeProvider =>
      pRestCategoriesIdRecipesProvider(
        categoryId: widget.id,
        pageProviderId: widget.pageKey,
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
    final category = ref.watch(widget.provider);

    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: category.value?.label ?? '',
        actions: [
          IconButton(
            onPressed: handleFilterDialog,
            icon: const Icon(MdiIcons.filter),
          ),
        ],
      ),
      body: SafeArea(
        child: FProviderState(
          provider: recipeProvider,
          onEmpty: FEmptyMessage(
            icon: StateIconConstants.recipes.emptyIcon,
            title: context.l10n.recipes_page__on_empty,
          ),
          onError: FEmptyMessage(
            icon: StateIconConstants.recipes.errorIcon,
            title: context.l10n.recipes_page__on_error,
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
                      shape: .l8_leaf_clover,
                      icon: MdiIcons.packageVariant,
                      description: context.l10n
                          .categories_item_page__description(
                            category.value?.label ?? '',
                          ),
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FLazySliverList(
                      key: orderKey,
                      provider: recipeProvider,
                      pageProvider: widget.pageProvider,
                      scrollController: _scrollController,

                      itemBuilder: (item, index, first, last) =>
                          FContentSideCard(
                            title: item.label,
                            imageSelector: item.cover?.url,
                            onTap: () => context.routes.recipesItem(item.id),
                            first: first,
                            last: last,
                          ),
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

  void handleFilterDialog() async {
    final result = await openFilterDialog();
    if (result != null) {
      ref.read(widget.pageProvider.notifier).reset();
    }
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.recipe;
}
