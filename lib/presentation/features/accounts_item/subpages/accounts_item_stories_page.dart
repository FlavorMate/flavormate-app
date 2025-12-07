import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_stories.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsItemStoriesPage extends ConsumerStatefulWidget {
  final String id;

  const AccountsItemStoriesPage({super.key, required this.id});

  String get pageProviderId => PageableState.accountStories.getId(id);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<AccountsItemStoriesPage> createState() =>
      _AccountsItemStoriesPageState();
}

class _AccountsItemStoriesPageState
    extends ConsumerState<AccountsItemStoriesPage>
    with FOrderMixin<AccountsItemStoriesPage> {
  PRestAccountsIdStoriesProvider get provider => pRestAccountsIdStoriesProvider(
    accountId: widget.id,
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: L10n.of(context).accounts_item_stories_page__title,
      provider: provider,
      pageProvider: widget.pageProvider,
      onEmpty: FEmptyMessage(
        title: L10n.of(context).accounts_item_stories_page__on_empty,
        icon: StateIconConstants.stories.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).accounts_item_stories_page__on_error,
        icon: StateIconConstants.stories.errorIcon,
      ),
      sortBuilder: () => FPaginatedSort(
        currentOrderBy: orderBy,
        currentDirection: orderDirection,
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
        options: OrderByConstants.story,
      ),
      itemBuilder: (item) => FImageCard.maximized(
        label: item.label,
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.storiesItem(item.id),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
