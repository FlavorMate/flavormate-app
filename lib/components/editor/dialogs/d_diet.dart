import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DDiet extends StatelessWidget {
  final Diet? diet;

  const DDiet({super.key, required this.diet});

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: L10n.of(context).d_editor_diet_title,
      child: TColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final diet in Diet.values)
            TButton(
              onPressed: () => context.pop(diet),
              leading: Icon(diet.icon),
              label: diet.getName(context),
              trailing: this.diet == diet
                  ? const Icon(MdiIcons.checkCircleOutline)
                  : null,
            ),
        ],
      ),
    );
  }
}
