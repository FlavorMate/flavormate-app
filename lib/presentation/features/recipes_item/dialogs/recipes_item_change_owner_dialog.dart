import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipesItemChangeOwnerDialog extends ConsumerStatefulWidget {
  const RecipesItemChangeOwnerDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipesItemChangeOwnerDialogState();

  static final pageKey = PageableState.recipeAccountList.name;

  PPageableStateProvider get pageProvider => pPageableStateProvider(pageKey);
}

class _RecipesItemChangeOwnerDialogState
    extends ConsumerState<RecipesItemChangeOwnerDialog>
    with FOrderMixin {
  final _scrollController = ScrollController();

  PRestAccountsProvider get provider => pRestAccountsProvider(
    RecipesItemChangeOwnerDialog.pageKey,
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
    return FAlertDialog(
      height: 450,
      scrollable: false,
      title: context.l10n.recipes_item_change_owner_dialog__title,
      negativeLabel: context.l10n.btn_close,
      actions: [
        TextButton.icon(
          onPressed: handleFilterDialog,
          label: Text(context.l10n.btn_filter),
          icon: const Icon(MdiIcons.filter),
        ),
      ],
      child: FProviderState(
        provider: provider,
        onError: FEmptyMessage(
          title: context.l10n.recipes_item_change_owner_dialog__on_error,
          icon: StateIconConstants.authors.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: context.l10n.recipes_item_change_owner_dialog__on_error,
          icon: StateIconConstants.authors.emptyIcon,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FLazySliverList(
              key: orderKey,
              provider: provider,
              pageProvider: widget.pageProvider,
              scrollController: _scrollController,
              itemBuilder: (item, index, first, last) {
                return FTile.manual(
                  first: first,
                  last: last,
                  tile: FTile(
                    leading: FCircleAvatar(account: item),
                    label: item.displayName,
                    subLabel: '@${item.username}',
                    onTap: () => submit(item),
                  ),
                );
              },
            ),
          ],
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

  void submit(AccountDto account) {
    context.pop(account.id);
  }

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.account;

  @override
  OrderBy get defaultOrderBy => .DisplayName;
}
