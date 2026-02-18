import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_books.dart';
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

class AccountsItemBooksPage extends ConsumerStatefulWidget {
  final String id;

  const AccountsItemBooksPage({super.key, required this.id});

  String get providerKey => PageableState.accountBook.getId(id);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(providerKey);

  @override
  ConsumerState<AccountsItemBooksPage> createState() =>
      _AccountsItemBooksPageState();
}

class _AccountsItemBooksPageState extends ConsumerState<AccountsItemBooksPage>
    with FOrderMixin<AccountsItemBooksPage> {
  final _scrollController = ScrollController();

  PRestAccountsIdBooksProvider get provider => pRestAccountsIdBooksProvider(
    accountId: widget.id,
    pageProviderId: widget.providerKey,
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
    final account = ref.watch(pRestAccountsIdProvider(widget.id)).value;

    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: context.l10n.accounts_item_books_page__title,
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
            title: context.l10n.accounts_item_books_page__on_empty,
            icon: StateIconConstants.books.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.accounts_item_books_page__on_error,
            icon: StateIconConstants.books.errorIcon,
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
                      shape: .pill,
                      icon: MdiIcons.book,
                      description: context.l10n
                          .accounts_item_books_page__description(
                            account?.displayName ?? '',
                          ),
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
                            subtitle: item.visible
                                ? context.l10n.accounts_item_books_page__visible
                                : context
                                      .l10n
                                      .accounts_item_books_page__invisible,
                            imageSelector: item.cover?.url,
                            onTap: () => context.routes.libraryItem(item.id),
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
  List<OrderBy> get allowedFilters => OrderByConstants.book;
}
