import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_link_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/extension/oidc/p_oidc_link.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_oidc/f_oidc_icon.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/features/settings/settings_account/settings_account_oidc_link/dialogs/settings_account_oidc_link_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountOidcLinkPage extends ConsumerStatefulWidget {
  const SettingsAccountOidcLinkPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAccountOidcLinkPageState();

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  String get pageProviderId => PageableState.oidcLink.name;
}

class _SettingsAccountOidcLinkPageState
    extends ConsumerState<SettingsAccountOidcLinkPage>
    with FOrderMixin {
  POidcLinkProvider get provider => pOidcLinkProvider(
    pageId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_account_oidc_link_page__title,
      ),
      body: FPageable(
        provider: provider,
        pageProvider: widget.pageProvider,
        onEmpty: FEmptyMessage(
          title: context.l10n.settings_account_oidc_link_page__on_empty,
          icon: StateIconConstants.oidc.emptyIcon,
        ),
        onError: FEmptyMessage(
          title: context.l10n.settings_account_oidc_link_page__on_error,
          icon: StateIconConstants.oidc.errorIcon,
        ),
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: OrderByConstants.oidc,
          padding: padding,
        ),
        builder: (context, data) {
          return FTileGroup(
            items: List.generate(data.length, (index) {
              final link = data[index];

              return FTile(
                leading: FOidcIcon(
                  data: link.icon,
                  label: link.providerName,
                ),
                label: link.providerName,
                subLabel: link.name,

                onTap: () => openInfoDialog(context, link),
                trailing: IconButton(
                  color: context.blendedColors.error,
                  onPressed: () => deleteLink(context, ref, link),
                  icon: const Icon(MdiIcons.delete),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  void openInfoDialog(BuildContext context, OidcLinkDto link) {
    showDialog(
      context: context,
      builder: (_) => SettingsAccountOidcLinkInfoDialog(link: link),
    );
  }

  void deleteLink(BuildContext context, WidgetRef ref, OidcLinkDto link) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context.l10n.settings_account_oidc_link_page__delete_title,
        content: context.l10n.settings_account_oidc_link_page__delete_hint(
          link.providerName,
        ),
      ),
    );

    if (!context.mounted || result != true) return;

    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).deleteLink(link);

    if (!context.mounted) return;
    context.pop();

    if (response.hasError) {
      context.showErrorSnackBar(
        context.l10n.settings_account_oidc_link_page__delete_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_oidc_link_page__delete_success,
      );
    }
  }

  @override
  OrderBy get defaultOrderBy => .Label;
}
