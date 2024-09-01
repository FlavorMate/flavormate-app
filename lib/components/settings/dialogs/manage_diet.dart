import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageDiet extends StatelessWidget {
  const ManageDiet({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.of(context).d_settings_manage_diet_title),
      content: SizedBox(
        width: 250,
        child: TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final diet in Diet.values)
              TIconButton(
                onPressed: () => context.pop(diet),
                icon: diet.icon,
                label: diet.getName(context),
              ),
          ],
        ),
      ),
    );
  }
}
