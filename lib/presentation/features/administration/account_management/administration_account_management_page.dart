import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/models/account_create_form.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/admin/p_rest_admin_accounts.dart';
import 'package:flavormate/presentation/common/dialogs/avatar/avatar_utils.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_2d_table.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_lazy_table.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/administration/account_management/dialogs/administration_account_management_actions_dialog.dart';
import 'package:flavormate/presentation/features/administration/account_management/dialogs/administration_account_management_new_account_dialog.dart';
import 'package:flavormate/presentation/features/administration/account_management/dialogs/administration_account_management_password_dialog.dart';
import 'package:flavormate/presentation/features/administration/account_management/enums/administration_account_management_actions.dart';
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
  final _scrollController = ScrollController();

  PRestAdminAccountsProvider get provider => pRestAdminAccountsProvider(
    pageProviderId: widget.pageProviderId,
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
    final self = ref.watch(pRestAccountsSelfProvider).requireValue;

    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: context.l10n.administration_account_management_page__title,
        actions: [
          IconButton(
            onPressed: handleFilterDialog,
            icon: const Icon(MdiIcons.filter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createAccount,
        child: const Icon(MdiIcons.plus),
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          // This state should never happen
          onEmpty: FEmptyMessage(
            title: '',
            icon: StateIconConstants.authors.emptyIcon,
          ),
          onError: FEmptyMessage(
            title:
                context.l10n.administration_account_management_page__on_error,
            icon: StateIconConstants.authors.errorIcon,
          ),
          child: FLazyTable<AccountFullDto>(
            key: orderKey,
            provider: provider,
            pageProvider: widget.pageProvider,
            scrollController: _scrollController,
            rowHeight: 64,
            pinnedHeader: true,
            pinnedColumn: true,
            columns: [
              FExpressiveTableColumn(
                flex: 1,
                minWidth: 192,
                header: Text(
                  context.l10n.administration_account_management_page__username,
                ),
                cellBuilder: (context, item, rowIndex) => Text(
                  '@${item.username}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 64,
                header: const Center(child: Icon(MdiIcons.account)),
                cellBuilder: (context, item, rowIndex) => FCircleAvatar(
                  account: item,
                  radius: 32 - 16,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 192,
                header: Text(
                  context
                      .l10n
                      .administration_account_management_page__display_name,
                ),
                cellBuilder: (context, item, rowIndex) => Text(
                  item.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 192,
                header: Text(
                  context.l10n.administration_account_management_page__e_mail,
                ),
                cellBuilder: (context, item, rowIndex) => Text(
                  item.email,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 128,
                alignment: .center,
                header: Text(
                  context
                      .l10n
                      .administration_account_management_page__account_enabled,
                ),
                cellBuilder: (context, item, rowIndex) => Icon(
                  item.enabled
                      ? MdiIcons.checkCircleOutline
                      : MdiIcons.circleOutline,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 128,
                alignment: .center,
                header: Text(
                  context
                      .l10n
                      .administration_account_management_page__account_verified,
                ),
                cellBuilder: (context, item, rowIndex) => Icon(
                  item.verified
                      ? MdiIcons.checkCircleOutline
                      : MdiIcons.circleOutline,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 192,
                header: Text(
                  context
                      .l10n
                      .administration_account_management_page__registration_date,
                ),
                cellBuilder: (context, item, rowIndex) => FText(
                  item.createdOn.formatter.date.yyyyMMdd(context),
                  style: .bodyMedium,
                  maxLines: 2,
                  fontFamily: .monospace,
                ),
              ),
              FExpressiveTableColumn(
                fixedWidth: 192,
                header: Text(
                  context
                      .l10n
                      .administration_account_management_page__last_activity,
                ),
                cellBuilder: (context, item, rowIndex) => FText(
                  item.lastActivity?.formatter.dateTime.yyMMddHHmm(context) ??
                      '-',
                  style: .bodyMedium,
                  maxLines: 2,
                  fontFamily: .monospace,
                ),
              ),
            ],
            onRowTap: (index, item) => showOptions(item, item.id == self.id),
          ),
        ),
      ),
    );
  }

  void showOptions(AccountFullDto account, bool isCurrent) async {
    final result = await showDialog<AdministrationAccountManagementActions>(
      context: context,
      builder: (_) => AdministrationAccountManagementActionsDialog(
        account: account,
        isCurrent: isCurrent,
      ),
    );

    if (!mounted || result == null) return;

    switch (result) {
      case .Open:
        await openAccount(account);
        break;
      case .Avatar:
        if (account.avatar != null) {
          context.showFullscreenImage(account.avatar!.url(.Original));
        }
        break;
      case .AvatarChange:
        await changeAvatar(account);
        break;
      case AdministrationAccountManagementActions.Enable:
        await toggleActiveState(account);
        break;
      case AdministrationAccountManagementActions.ResetPassword:
        await setPassword(account);
        break;
      case AdministrationAccountManagementActions.Delete:
        await deleteAccount(account);
        break;
    }

    resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
  }

  Future<void> deleteAccount(AccountFullDto account) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context
            .l10n
            .administration_account_management_page__delete_account_title,
        content: context
            .l10n
            .administration_account_management_page__delete_account_hint_1,
      ),
    );

    if (confirmation != true || !mounted) return;

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).deleteAccount(account.id);

    if (result.hasError) {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        context.l10n.recipes_item_page__delete_failure,
      );
    } else {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        context.l10n.recipes_item_page__delete_success,
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
        context.l10n.recipes_item_page__delete_failure,
      );
    } else {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        context.l10n.recipes_item_page__delete_success,
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
        context.l10n.recipes_item_page__create_failure,
      );
    } else {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        context.l10n.recipes_item_page__create_success,
      );
    }
  }

  Future<void> openAccount(AccountFullDto account) async {
    await context.routes.accountsItem(account.id);
  }

  Future<void> changeAvatar(AccountFullDto account) async {
    await AvatarUtils.manageAvatar(context, ref, account);

    ref.invalidate(provider);
  }

  void handleSorting(int xIndex) {
    final columnOrderBy = switch (xIndex) {
      0 => OrderBy.Username,
      2 => OrderBy.DisplayName,
      3 => OrderBy.EMail,
      6 => OrderBy.CreatedOn,
      7 => OrderBy.LastActivity,
      _ => null,
    };

    if (columnOrderBy == null) return;

    setState(() {
      orderDirection ??= .Ascending;
      if (orderBy == columnOrderBy) {
        if (orderDirection == .Ascending) {
          orderDirection = .Descending;
        } else {
          orderDirection = .Ascending;
        }
      } else {
        orderBy = columnOrderBy;
        orderDirection = .Ascending;
      }
      resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
    });
  }

  void handleFilterDialog() async {
    final result = await openFilterDialog();
    if (result != null) {
      resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
    }
  }

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.adminAccount;

  @override
  OrderBy get defaultOrderBy => OrderBy.Username;
}
