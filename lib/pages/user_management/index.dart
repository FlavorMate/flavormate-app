import 'package:data_table_2/data_table_2.dart';
import 'package:flavormate/components/dialogs/t_confirm_dialog.dart';
import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/user_management/dialog/change_password_dialog.dart';
import 'package:flavormate/components/user_management/dialog/create_user_dialog.dart';
import 'package:flavormate/extensions/e_date_time.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/user/user.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:flavormate/riverpod/user/p_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  int? currentSortIndex;
  bool sortASC = true;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pUsersProvider);
    final userProvider = ref.watch(pUserProvider);

    final double columnSpacing = 10;
    final double horizontalMargin = 24;

    final double minWidth = horizontalMargin * 2 +
        columnSpacing * 6 +
        128 +
        128 +
        160 +
        64 +
        128 +
        64;

    return RScaffold(
      userProvider,
      appBar: TAppBar(title: L10n.of(context).p_admin_user_management_title),
      floatingActionButton: (_, __) => FloatingActionButton(
        onPressed: () => createUser(context, ref),
        child: const Icon(MdiIcons.plus),
      ),
      builder: (_, currentUser) => RStruct(
        provider,
        (_, users) => DataTable2(
          isHorizontalScrollBarVisible: true,
          isVerticalScrollBarVisible: true,
          minWidth: minWidth,
          columnSpacing: columnSpacing,
          horizontalMargin: horizontalMargin,
          sortColumnIndex: currentSortIndex,
          sortAscending: sortASC,
          sortArrowIcon: MdiIcons.chevronUp,
          columns: [
            DataColumn2(
              label: Text(L10n.of(context).p_admin_user_management_username),
              fixedWidth: 128,
              onSort: (i, j) => sort(i),
            ),
            DataColumn2(
              label: Text(L10n.of(context).p_admin_user_management_displayname),
              fixedWidth: 128,
              onSort: (i, j) => sort(i),
            ),
            DataColumn2(
              label:
                  Text(L10n.of(context).p_admin_user_management_last_activity),
              fixedWidth: 160,
              onSort: (i, j) => sort(i),
            ),
            DataColumn2(
              label: Text(L10n.of(context).p_admin_user_management_is_active),
              fixedWidth: 64,
            ),
            DataColumn2(
              label:
                  Text(L10n.of(context).p_admin_user_management_set_password),
              fixedWidth: 128,
            ),
            DataColumn2(
              label: Text(L10n.of(context).p_admin_user_management_delete),
              fixedWidth: 64,
            ),
          ],
          rows: [
            for (final user in users)
              DataRow2(
                cells: [
                  DataCell(Text(user.username)),
                  DataCell(Text(user.displayName)),
                  DataCell(
                    Text(user.lastActivity!.toLocalDateTimeString2(context)),
                  ),
                  DataCell(
                    Center(
                      child: IconButton(
                        onPressed: currentUser.id! == user.id
                            ? null
                            : () =>
                                toggleActiveState(ref, user.id!, !user.valid!),
                        icon: user.valid!
                            ? const Icon(MdiIcons.lockOpen)
                            : const Icon(MdiIcons.lockOff),
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: IconButton(
                        onPressed: currentUser.id! == user.id
                            ? null
                            : () => changePassword(context, ref, user),
                        icon: const Icon(MdiIcons.formTextboxPassword),
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: IconButton(
                        onPressed: currentUser.id! == user.id
                            ? null
                            : () => deleteUser(context, ref, user),
                        icon: const Icon(
                          MdiIcons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  sort(int index) {
    if (currentSortIndex != index) {
      setState(() {
        sortASC = false;
        currentSortIndex = index;
      });
    }

    setState(() => sortASC = !sortASC);
    switch (index) {
      case 0:
        ref.read(pUsersProvider.notifier).sortByUsername(sortASC);
        return;
      case 1:
        ref.read(pUsersProvider.notifier).sortByDisplayname(sortASC);
        return;
      case 2:
        ref.read(pUsersProvider.notifier).sortByLastActivity(sortASC);
        return;
    }
  }

  toggleActiveState(WidgetRef ref, int id, bool newState) async {
    await ref
        .read(pApiProvider)
        .userClient
        .update(id, data: {'valid': newState});
    ref.invalidate(pUsersProvider);
  }

  deleteUser(BuildContext context, WidgetRef ref, User user) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => TConfirmDialog(
        title: L10n.of(context)
            .d_admin_user_management_delete_title(user.username),
      ),
    );
    if (response == true) {
      await ref.read(pApiProvider).userClient.deleteById(user.id!);
      ref.invalidate(pUsersProvider);
    }
  }

  changePassword(BuildContext context, WidgetRef ref, User user) async {
    final response = await showDialog<Map>(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
    if (response != null) {
      await ref.read(pApiProvider).userClient.forcePassword(user.id!, response);
      ref.invalidate(pUsersProvider);
    }
  }

  createUser(BuildContext context, WidgetRef ref) async {
    final form = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const CreateUserDialog(),
    );

    if (form != null) {
      await ref.read(pApiProvider).userClient.create(data: form);
      ref.invalidate(pUsersProvider);
    }
  }
}
