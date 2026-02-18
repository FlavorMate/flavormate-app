import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
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

class HomeStoriesPage extends ConsumerStatefulWidget {
  const HomeStoriesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeStoriesPageState();

  static final pageKey = PageableState.storiesFull.name;

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);
}

class _HomeStoriesPageState extends ConsumerState<HomeStoriesPage>
    with FOrderMixin {
  final _scrollController = ScrollController();

  PRestStoriesProvider get provider => pRestStoriesProvider(
    HomeStoriesPage.pageKey,
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
        scrollController: _scrollController,
        title: context.l10n.home_stories_page__title,
        actions: [
          IconButton(
            onPressed: handleFilterDialog,
            icon: const Icon(MdiIcons.filter),
          ),
        ],
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.home_stories_page__on_empty,
            icon: StateIconConstants.stories.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.home_stories_page__on_error,
            icon: StateIconConstants.stories.errorIcon,
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
                      shape: .l4_leaf_clover,
                      icon: MdiIcons.forum,
                      description: context.l10n.home_stories_page__description,
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
                            imageSelector: item.cover?.url,
                            onTap: () => context.routes.storiesItem(item.id),
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
  OrderDirection get defaultOrderDirection => OrderDirection.Descending;

  @override
  OrderBy get defaultOrderBy => OrderBy.CreatedOn;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.story;
}
