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

class UserManagementPage extends ConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pUsersProvider);
    final userProvider = ref.watch(pUserProvider);

    return RScaffold(
      userProvider,
      appBar: TAppBar(title: L10n.of(context).p_admin_user_management_title),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createUser(context, ref),
        child: const Icon(MdiIcons.plus),
      ),
      builder: (_, currentUser) => SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RStruct(
            provider,
            (context, users) => DataTable(
              columns: [
                DataColumn(
                  label:
                      Text(L10n.of(context).p_admin_user_management_username),
                ),
                DataColumn(
                  label: Text(
                      L10n.of(context).p_admin_user_management_displayname),
                ),
                DataColumn(
                  label: Text(
                      L10n.of(context).p_admin_user_management_last_activity),
                ),
                DataColumn(
                  label:
                      Text(L10n.of(context).p_admin_user_management_is_active),
                ),
                DataColumn(
                  label: Text(
                      L10n.of(context).p_admin_user_management_set_password),
                ),
                DataColumn(
                  label: Text(L10n.of(context).p_admin_user_management_delete),
                ),
              ],
              rows: [
                for (final user in users)
                  DataRow(
                    cells: [
                      DataCell(Text(user.username)),
                      DataCell(Text(user.displayName)),
                      DataCell(Text(
                          user.lastActivity!.toLocalDateTimeString(context))),
                      DataCell(
                        Center(
                          child: IconButton(
                            onPressed: currentUser.id! == user.id
                                ? null
                                : () => toggleActiveState(
                                    ref, user.id!, !user.valid!),
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
                            icon: const Icon(MdiIcons.delete),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
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
