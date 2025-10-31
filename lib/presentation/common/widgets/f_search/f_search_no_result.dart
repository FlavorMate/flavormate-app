import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FSearchNoResult extends StatelessWidget {
  const FSearchNoResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(MdiIcons.mushroomOffOutline, size: 64),
          const SizedBox(height: PADDING),
          FText(
            L10n.of(context).f_search_no_result__title,
            style: FTextStyle.titleLarge,
          ),
        ],
      ),
    );
  }
}
