import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/enums/home_account_dialog_avatar_result.dart';

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class HomeAccountDialogAvatarDialog extends StatelessWidget {
  const HomeAccountDialogAvatarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: L10n.of(context).home_account_dialog_avatar_dialog__title,
      child: SizedBox(
        child: Column(
          spacing: PADDING,
          mainAxisSize: MainAxisSize.min,
          children: [
            FIconButton(
              onPressed: () =>
                  context.pop(HomeAccountDialogAvatarResult.Change),
              icon: MdiIcons.accountPlusOutline,
              label: L10n.of(context).home_account_dialog_avatar_dialog__change,
            ),
            FIconButton(
              onPressed: () =>
                  context.pop(HomeAccountDialogAvatarResult.Delete),
              icon: MdiIcons.accountMinusOutline,
              label: L10n.of(context).home_account_dialog_avatar_dialog__delete,
            ),
          ],
        ),
      ),
    );
  }
}
