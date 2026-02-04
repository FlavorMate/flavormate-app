import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_recipes.dart';
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

class AccountsItemRecipesPage extends ConsumerStatefulWidget {
  final String id;

  const AccountsItemRecipesPage({super.key, required this.id});

  String get pageKey => PageableState.accountRecipes.getId(id);

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);

  @override
  ConsumerState<AccountsItemRecipesPage> createState() =>
      _AccountsItemRecipesPageState();
}

class _AccountsItemRecipesPageState
    extends ConsumerState<AccountsItemRecipesPage>
    with FOrderMixin<AccountsItemRecipesPage> {
  final _controller = ScrollController();

  PRestAccountsIdRecipesProvider get provider => pRestAccountsIdRecipesProvider(
    accountId: widget.id,
    pageProviderId: widget.pageKey,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(pRestAccountsIdProvider(widget.id)).value;

    return Scaffold(
      appBar: FAppBar(
        controller: _controller,
        title: context.l10n.accounts_item_recipe_page__title,
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
            title: context.l10n.accounts_item_recipe_page__on_empty,
            icon: StateIconConstants.recipes.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.accounts_item_recipe_page__on_error,
            icon: StateIconConstants.recipes.errorIcon,
          ),
          child: CustomScrollView(
            controller: _controller,
            slivers: [
              FConstrainedBoxSliver(
                maxWidth: FBreakpoint.smValue,
                padding: const .all(PADDING),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    FPageIntroductionSliver(
                      shape: .c7_sided_cookie,
                      icon: MdiIcons.foodVariant,
                      description: context.l10n
                          .accounts_item_recipes_page__description(
                            account?.displayName ?? '',
                          ),
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FLazySliverList(
                      key: orderKey,
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _controller,

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
