import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class ServerMajorIncompatible extends StatelessWidget {
  const ServerMajorIncompatible({super.key});

  @override
  Widget build(BuildContext context) {
    return TCard(
      color: Colors.red,
      child: TRow(
        children: [
          Icon(MdiIcons.closeOctagonOutline),
          SizedBox(
            child: TText(
              L10n.of(
                context,
              ).p_login_server_outdated_major.replaceAll('\\n', '\n'),
              TextStyles.bodyMedium,
              color: TextColor.white,
            ),
          ),
        ],
      ),
    );
  }
}
