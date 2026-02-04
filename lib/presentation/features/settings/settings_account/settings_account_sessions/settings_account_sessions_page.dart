import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
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
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/features/settings/settings_account/settings_account_sessions/dialogs/settings_account_sessions_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/v4.dart';

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
  late String seed;

  PSessionsProvider get provider => pSessionsProvider(
    pageId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  final _controller = ScrollController();

  @override
  void initState() {
    seed = const UuidV4().generate();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refreshToken = ref.watch(pSSJwtProvider).requireValue!.refreshToken;
    final hashedToken = UJWT.hashToken(refreshToken);

    return Scaffold(
      appBar: FAppBar(
        controller: _controller,
        title: context.l10n.settings_account_sessions_page__title,
        actions: [
          IconButton(
            onPressed: handleFilterDialog,
            icon: const Icon(MdiIcons.filter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteAllSessionsButCurrent(),
        child: const Icon(MdiIcons.logout),
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            // This state should never happen
            title: '',
            icon: StateIconConstants.login.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.settings_account_sessions_page__on_error,
            icon: StateIconConstants.login.errorIcon,
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
                      shape: Shapes.c4_sided_cookie,
                      icon: MdiIcons.key,
                      description:
                          context.l10n.settings_account_sessions_page__hint,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FLazySliverList(
                      key: ValueKey('${orderKey.value}-$seed'),
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _controller,

                      itemBuilder: (item, index, first, last) {
                        final link = item;

                        final currentSession = hashedToken == link.tokenHash;

                        return FTile.manual(
                          first: first,
                          last: last,
                          tile: FTile(
                            label: link.userAgent?.device ?? '-',
                            subLabel: link.createdAt.toLocalDateTimeString(
                              context,
                            ),
                            onTap: () => openInfoDialog(context, link),
                            trailing: IconButton(
                              color: context.blendedColors.error,
                              onPressed: currentSession
                                  ? null
                                  : () => deleteSession(link),
                              icon: const Icon(MdiIcons.delete),
                            ),
                          ),
                        );
                      },
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    const FSizedBoxSliver(height: kFabHeight),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      setState(() {
        ref.read(widget.pageProvider.notifier).reset();
        seed = const UuidV4().generate();
      });
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
      setState(() {
        ref.read(widget.pageProvider.notifier).reset();
        seed = const UuidV4().generate();
      });
      context.showTextSnackBar(
        context.l10n.settings_account_sessions_page__delete_all_success,
      );
    }
  }

  void handleFilterDialog() async {
    final result = await openFilterDialog();
    if (result != null) {
      ref.read(widget.pageProvider.notifier).reset();
    }
  }

  @override
  OrderBy get defaultOrderBy => .CreatedOn;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.session;
}
