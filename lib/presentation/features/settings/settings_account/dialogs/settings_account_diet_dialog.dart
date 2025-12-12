import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountDietDialog extends StatelessWidget {
  final Diet currentDiet;

  const SettingsAccountDietDialog({super.key, required this.currentDiet});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.settings_account_diet_dialog__title),
      scrollable: true,
      constraints: const BoxConstraints(
        minWidth: 560,
        maxWidth: 560,
      ),
      insetPadding: const .all(PADDING),
      content: FTileGroup(
        items: List.generate(Diet.values.length, (index) {
          final item = Diet.values[index];
          return FTile(
            label: item.getName(context),
            subLabel: null,
            leading: FTileIcon(
              iconBackgroundColor: Colors.transparent,
              icon: currentDiet == item
                  ? MdiIcons.checkCircleOutline
                  : MdiIcons.circleOutline,
            ),
            onTap: () => context.pop(AccountUpdateDto(diet: item)),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.btn_close),
        ),
      ],
    );
  }
}
