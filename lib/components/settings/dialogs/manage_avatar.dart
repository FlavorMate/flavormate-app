import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class ManageAvatar extends StatelessWidget {
  const ManageAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: L10n.of(context).d_settings_manage_avatar_title,
      child: SizedBox(
        width: 250,
        child: TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            TIconButton(
              onPressed: () => context.pop('change'),
              icon: MdiIcons.accountPlusOutline,
              label: L10n.of(context).d_settings_manage_avatar_change,
            ),
            TIconButton(
              onPressed: () => context.pop('delete'),
              icon: MdiIcons.accountMinusOutline,
              label: L10n.of(context).d_settings_manage_avatar_delete,
            ),
          ],
        ),
      ),
    );
  }
}
