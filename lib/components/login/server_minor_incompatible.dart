import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class ServerMinorIncompatible extends StatelessWidget {
  const ServerMinorIncompatible({super.key});

  @override
  Widget build(BuildContext context) {
    return TCard(
      color: Colors.orange,
      child: TRow(
        children: [
          Icon(MdiIcons.alertCircleOutline),
          TText(
            L10n.of(
              context,
            ).p_login_server_outdated_minor.replaceAll('\\n', '\n'),
            TextStyles.bodyMedium,
            color: TextColor.white,
          ),
        ],
      ),
    );
  }
}
