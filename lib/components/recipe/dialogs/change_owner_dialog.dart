import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_rounded_list_tile.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/riverpod/user/p_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangeOwnerDialog extends ConsumerWidget {
  const ChangeOwnerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pUsersProvider);
    return TAlertDialog(
      title: L10n.of(context).d_recipe_change_owner_title,
      child: RStruct(
        provider,
        (_, users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];
            return TRoundedListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: user.avatar?.path != null
                    ? Image.network(
                        user.avatar!.path(context.read(pServerProvider)!),
                        height: 28,
                        width: 28,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 28,
                        width: 28,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Center(
                          child: Text(user.displayName[0]),
                        ),
                      ),
              ),
              title: Text(user.displayName),
              onTap: () => context.pop(user.id),
            );
          },
        ),
      ),
    );
  }
}
