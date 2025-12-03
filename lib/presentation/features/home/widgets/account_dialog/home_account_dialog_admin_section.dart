import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class HomeAccountDialogAdminSection extends StatelessWidget {
  const HomeAccountDialogAdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FTileGroup(
      items: [
        FTile(
          label: L10n.of(
            context,
          ).home_account_dialog_admin_section__account_management,
          icon: MdiIcons.accountGroupOutline,
          onTap: () => openAdminAccountPage(context),
        ),
      ],
    );
  }

  void openAdminAccountPage(BuildContext context) {
    context.pop();
    context.routes.administrationAccountManagement();
  }
}
