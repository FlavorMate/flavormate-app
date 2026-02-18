import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
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
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_oidc/f_oidc_icon.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/features/settings/settings_account/settings_account_oidc_link/dialogs/settings_account_oidc_link_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/v4.dart';

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
  late String seed;

  POidcLinkProvider get provider => pOidcLinkProvider(
    pageId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    seed = const UuidV4().generate();
    super.initState();
  }

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
        title: context.l10n.settings_account_oidc_link_page__title,
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
            title: context.l10n.settings_account_oidc_link_page__on_empty,
            icon: StateIconConstants.oidc.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.settings_account_oidc_link_page__on_error,
            icon: StateIconConstants.oidc.errorIcon,
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
                      shape: .puffy_diamond,
                      icon: MdiIcons.linkVariant,
                      description: context
                          .l10n
                          .settings_account_oidc_link_page__description,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FLazySliverList(
                      key: ValueKey('${orderKey.value}-$seed'),
                      provider: provider,
                      pageProvider: widget.pageProvider,
                      scrollController: _scrollController,

                      itemBuilder: (link, index, first, last) {
                        return FTile.manual(
                          first: first,
                          last: last,
                          tile: FTile(
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
                          ),
                        );
                      },
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
      setState(() {
        ref.read(widget.pageProvider.notifier).reset();
        seed = const UuidV4().generate();
      });

      context.showTextSnackBar(
        context.l10n.settings_account_oidc_link_page__delete_success,
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
  OrderBy get defaultOrderBy => .Label;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.oidc;
}
