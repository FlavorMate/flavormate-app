import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            MdiIcons.mushroomOffOutline,
            size: 64,
          ),
          const SizedBox(height: PADDING),
          TText(L10n.of(context).c_search_nothing_found, TextStyles.titleLarge),
        ],
      ),
    );
  }
}
