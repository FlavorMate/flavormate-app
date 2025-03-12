import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ManageDiet extends ConsumerWidget {
  const ManageDiet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pUserProvider);
    return TAlertDialog(
      title: L10n.of(context).d_settings_manage_diet_title,
      child: RStruct(
        provider,
        (_, user) => TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final diet in Diet.values)
              TButton(
                onPressed: () => context.pop(diet),
                leading: Icon(diet.icon),
                label: diet.getName(context),
                trailing:
                    user.diet == diet
                        ? const Icon(MdiIcons.checkCircleOutline)
                        : null,
              ),
          ],
        ),
      ),
    );
  }
}
