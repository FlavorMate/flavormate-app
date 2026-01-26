import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/core/storage/secure_storage/providers/p_ss_jwt.dart';
import 'package:flavormate/core/utils/u_jwt.dart';
import 'package:flavormate/data/models/core/auth/session_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/core/auth/p_sessions.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/features/settings/settings_account/settings_account_sessions/dialogs/settings_account_sessions_info_dialog.dart'
    show SettingsAccountSessionsInfoDialog;
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountSessionsPage extends ConsumerStatefulWidget {
  const SettingsAccountSessionsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAccountSessionsPageState();

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  String get pageProviderId => PageableState.sessions.name;
}

class _SettingsAccountSessionsPageState
    extends ConsumerState<SettingsAccountSessionsPage>
    with FOrderMixin {
  PSessionsProvider get provider => pSessionsProvider(
    pageId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    final refreshToken = ref.watch(pSSJwtProvider).requireValue!.refreshToken;
    final hashedToken = UJWT.hashToken(refreshToken);

    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_account_sessions_page__title,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteAllSessionsButCurrent(),
        child: const Icon(MdiIcons.logout),
      ),
      body: FPageable(
        provider: provider,
        pageProvider: widget.pageProvider,
        onEmpty: FEmptyMessage(
          // This state should never happen
          title: '',
          icon: StateIconConstants.login.emptyIcon,
        ),
        onError: FEmptyMessage(
          title: context.l10n.settings_account_sessions_page__on_error,
          icon: StateIconConstants.login.errorIcon,
        ),
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: OrderByConstants.session,
          padding: padding,
        ),
        builder: (context, data) {
          return FTileGroup(
            items: List.generate(data.length, (index) {
              final link = data[index];

              final currentSession = hashedToken == link.tokenHash;

              return FTile(
                label: link.userAgent?.device ?? '-',
                subLabel: link.createdAt.toLocalDateTimeString(context),
                onTap: () => openInfoDialog(context, link),
                trailing: IconButton(
                  color: context.blendedColors.error,
                  onPressed: currentSession ? null : () => deleteSession(link),
                  icon: const Icon(MdiIcons.delete),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  void openInfoDialog(BuildContext context, SessionDto session) {
    showDialog(
      context: context,
      builder: (_) => SettingsAccountSessionsInfoDialog(session: session),
    );
  }

  Future<void> deleteSession(SessionDto session) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context.l10n.settings_account_sessions_page__delete_title,
        content: context.l10n.settings_account_sessions_page__delete_hint,
      ),
    );

    if (!mounted || result != true) return;

    context.showLoadingDialog();

    final response = await ref.read(provider.notifier).delete(id: session.id);

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showErrorSnackBar(
        context.l10n.settings_account_sessions_page__delete_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_sessions_page__delete_success,
      );
    }
  }

  Future<void> deleteAllSessionsButCurrent() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context.l10n.settings_account_sessions_page__delete_all_title,
        content: context.l10n.settings_account_sessions_page__delete_all_hint,
      ),
    );

    if (!mounted || result != true) return;

    context.showLoadingDialog();

    final response = await ref
        .read(provider.notifier)
        .deleteAllSessionsButCurrent();

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showErrorSnackBar(
        context.l10n.settings_account_sessions_page__delete_all_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_sessions_page__delete_all_success,
      );
    }
  }

  @override
  OrderBy get defaultOrderBy => .CreatedOn;
}
