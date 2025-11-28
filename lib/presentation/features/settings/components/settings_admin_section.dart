import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsAdminSection extends StatelessWidget {
  const SettingsAdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: PADDING,
      child: Column(
        spacing: PADDING,
        children: [
          FText(
            L10n.of(context).settings_admin_section__title,
            style: FTextStyle.headlineMedium,
            weight: .w500,
          ),
          FIconButton(
            width: BUTTON_WIDTH,
            label: L10n.of(context).settings_admin_section__account_management,
            icon: MdiIcons.accountOutline,
            onPressed: () => context.routes.administrationAccountManagement(),
          ),
        ],
      ),
    );
  }
}
