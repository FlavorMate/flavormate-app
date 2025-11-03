import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/models/account_create_form.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/admin/p_rest_admin_accounts.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_simple_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/administration/account_management/dialogs/administration_account_management_new_account_dialog.dart';
import 'package:flavormate/presentation/features/administration/account_management/dialogs/administration_account_management_password_dialog.dart';
import 'package:flavormate/presentation/features/administration/account_management/enums/administration_account_management_actions.dart';
import 'package:flavormate/presentation/features/administration/account_management/widgets/administration_account_management_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdministrationAccountManagementPage extends ConsumerStatefulWidget {
  const AdministrationAccountManagementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountManagementPageState();

  String get pageProviderId =>
      PageableState.administrationAccountManagement.name;

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);
}

class _AccountManagementPageState
    extends ConsumerState<AdministrationAccountManagementPage>
    with FOrderMixin<AdministrationAccountManagementPage> {
  PRestAdminAccountsProvider get provider => pRestAdminAccountsProvider(
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: pRestAccountsSelfProvider,
      appBarBuilder: (_, _) => FAppBar(
        title: L10n.of(context).administration_account_management_page__title,
      ),
      floatingActionButtonBuilder: (_, _) => FloatingActionButton(
        onPressed: createAccount,
        child: const Icon(MdiIcons.plus),
      ),
      builder: (_, self) => FPageable(
        provider: provider,
        pageProvider: widget.pageProvider,
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: OrderByConstants.account,
          padding: padding,
        ),
        builder: (_, data) => FWrap(
          children: [
            for (final account in data)
              AdministrationAccountManagementCard(
                account: account,
                isOwnAccount: account.id == self.id,
                onTap: showOptions,
              ),
          ],
        ),
        onError: FEmptyMessage(
          title: L10n.of(
            context,
          ).administration_account_management_page__on_error,
          icon: StateIconConstants.authors.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(
            context,
          ).administration_account_management_page__on_empty,
          icon: StateIconConstants.authors.emptyIcon,
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(
          context,
        ).administration_account_management_page__self_on_error,
        icon: StateIconConstants.authors.errorIcon,
      ),
    );
  }

  void showOptions(AccountFullDto account) async {
    final result = await showDialog<AdministrationAccountManagementActions>(
      context: context,
      builder: (_) => FSimpleDialog<AdministrationAccountManagementActions>(
        title: L10n.of(
          context,
        ).administration_account_management_page__actions_title,
        options: [
          FSimpleDialogOption(
            label: account.enabled
                ? L10n.of(
                    context,
                  ).administration_account_management_page__actions_disable
                : L10n.of(
                    context,
                  ).administration_account_management_page__actions_enable,
            icon: MdiIcons.accountCheck,
            value: AdministrationAccountManagementActions.Enable,
          ),
          FSimpleDialogOption(
            label: L10n.of(
              context,
            ).administration_account_management_page__actions_set_password,
            icon: MdiIcons.lockReset,
            value: AdministrationAccountManagementActions.ResetPassword,
          ),
          FSimpleDialogOption(
            label: L10n.of(
              context,
            ).administration_account_management_page__actions_delete,
            icon: MdiIcons.delete,
            value: AdministrationAccountManagementActions.Delete,
          ),
        ],
      ),
    );

    if (!mounted || result == null) return;

    switch (result) {
      case AdministrationAccountManagementActions.Enable:
        await toggleActiveState(account);
        return;
      case AdministrationAccountManagementActions.ResetPassword:
        await setPassword(account);
        return;
      case AdministrationAccountManagementActions.Delete:
        await deleteAccount(account);
        return;
    }
  }

  Future<void> deleteAccount(AccountFullDto account) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(
          context,
        ).administration_account_management_page__delete_account_title,
        content: L10n.of(
          context,
        ).administration_account_management_page__delete_account_hint_1,
      ),
    );

    if (confirmation != true || !mounted) return;

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).deleteAccount(account.id);

    if (result.hasError) {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        L10n.of(context).recipes_item_page__delete_failure,
      );
    } else {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        L10n.of(context).recipes_item_page__delete_success,
      );
    }
  }

  Future<void> setPassword(AccountFullDto account) async {
    final newPassword = await showDialog<String>(
      context: context,
      builder: (_) => const AdministrationAccountManagementPasswordDialog(),
    );

    if (EString.isEmpty(newPassword) || !mounted) return;

    context.showLoadingDialog();

    final result = await ref
        .read(provider.notifier)
        .setPassword(account.id, newPassword!);

    if (result.hasError) {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        L10n.of(context).recipes_item_page__delete_failure,
      );
    } else {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        L10n.of(context).recipes_item_page__delete_success,
      );
    }
  }

  Future<void> toggleActiveState(AccountFullDto account) async {
    context.showLoadingDialog();
    await ref.read(provider.notifier).toggleActiveState(account.id);

    if (!mounted) return;
    context.pop();
  }

  Future<void> createAccount() async {
    final form = await showDialog<AccountCreateForm>(
      context: context,
      builder: (_) => const AdministrationAccountManagementNewAccountDialog(),
    );

    if (form == null || !mounted) return;

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).createAccount(form);

    if (result.hasError) {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        L10n.of(context).recipes_item_page__create_failure,
      );
    } else {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        L10n.of(context).recipes_item_page__create_success,
      );
    }
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Username;
}
