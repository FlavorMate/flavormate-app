import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_rounded_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipesItemChangeOwnerDialog extends StatelessWidget {
  const RecipesItemChangeOwnerDialog({super.key});

  PRestAccountsProvider get provider => pRestAccountsProvider(
    PageableState.recipeAccountList.name,
    orderBy: OrderBy.DisplayName,
  );

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.recipeAccountList.name);

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      height: 350,
      title: L10n.of(context).recipes_item_change_owner_dialog__title,
      child: FPageable(
        provider: provider,
        pageProvider: pageProvider,
        builder: (_, users) => Column(
          children: [
            for (final user in users)
              FRoundedListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FCircularAvatarViewer(
                    account: user,
                    height: 32,
                    width: 32,
                  ),
                ),
                title: Text(user.displayName),
                onTap: () => context.pop(user.id),
              ),
          ],
        ),
        onError: FEmptyMessage(
          title: L10n.of(context).recipes_item_change_owner_dialog__on_error,
          icon: StateIconConstants.authors.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(context).recipes_item_change_owner_dialog__on_error,
          icon: StateIconConstants.authors.emptyIcon,
        ),
      ),
    );
  }
}
