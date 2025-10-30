import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_stories.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
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
    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).accounts_item_stories_page__title,
      ),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: widget.pageProvider,
          filterBuilder: (padding) => FPageableSort(
            currentOrderBy: orderBy,
            currentDirection: orderDirection,
            setOrderBy: setOrderBy,
            setOrderDirection: setOrderDirection,
            options: const [OrderBy.Label, OrderBy.CreatedOn],
            padding: padding,
          ),
          builder: (_, stories) => FWrap(
            children: [
              for (final story in stories)
                FImageCard.maximized(
                  label: story.label,
                  coverSelector: (resolution) => story.cover?.url(resolution),
                  width: 400,
                  onTap: () => context.routes.storiesItem(story.id),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).accounts_item_stories_page__on_empty,
            icon: StateIconConstants.stories.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).accounts_item_stories_page__on_error,
            icon: StateIconConstants.stories.errorIcon,
          ),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
