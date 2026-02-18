import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
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

class HomeLatestPage extends ConsumerStatefulWidget {
  const HomeLatestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeLatestPageState();

  static final pageKey = PageableState.recipeLatestFull.name;

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);
}

class _HomeLatestPageState extends ConsumerState<HomeLatestPage>
    with FOrderMixin {
  final _scrollController = ScrollController();

  PRestRecipesProvider get provider => pRestRecipesProvider(
    HomeLatestPage.pageKey,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.home_latest_page__title,
        scrollController: _scrollController,
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.home_latest_page__on_empty,
            icon: StateIconConstants.recipes.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.home_latest_page__on_error,
            icon: StateIconConstants.recipes.errorIcon,
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
                      icon: MdiIcons.calendarClock,
                      description: context.l10n.home_latest_page__description,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FLazySliverList(
                      key: orderKey,
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _scrollController,

                      itemBuilder: (item, index, first, last) =>
                          FContentSideCard(
                            title: item.label,
                            subtitle: item.createdOn.formatter.date.yyyyMMMMdd(
                              context,
                            ),
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

  @override
  OrderDirection get defaultOrderDirection => OrderDirection.Descending;

  @override
  OrderBy get defaultOrderBy => OrderBy.CreatedOn;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.recipe;
}
