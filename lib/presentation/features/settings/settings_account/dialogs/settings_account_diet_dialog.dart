import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountDietDialog extends StatelessWidget {
  final Diet currentDiet;

  const SettingsAccountDietDialog({super.key, required this.currentDiet});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: L10n.of(context).settings_account_diet_dialog__title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: PADDING,
        children: [
          for (final diet in Diet.values)
            FButton(
              onPressed: () => context.pop(AccountUpdateDto(diet: diet)),
              leading: Icon(diet.icon),
              label: diet.getName(context),
              trailing: currentDiet == diet
                  ? const Icon(MdiIcons.checkCircleOutline)
                  : null,
            ),
        ],
      ),
    );
  }
}
