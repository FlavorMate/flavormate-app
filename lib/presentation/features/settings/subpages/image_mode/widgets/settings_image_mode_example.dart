import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_settings_image_mode.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsImageModeExample extends StatelessWidget {
  final String label;
  final String image;
  final SpSettingsImageMode value;
  final bool state;
  final void Function(SpSettingsImageMode) onTap;

  const SettingsImageModeExample({
    super.key,
    required this.label,
    required this.image,
    required this.value,
    required this.state,
    required this.onTap,
  });

  IconData get _icon =>
      state ? MdiIcons.checkCircleOutline : MdiIcons.circleOutline;

  @override
  Widget build(BuildContext context) {
    return FCard(
      onTap: () => onTap(value),
      child: Column(
        spacing: PADDING,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: Icon(_icon),
                ),
              ),
              FText(
                L10n.of(
                  context,
                ).settings_image_mode_page__fit_mode,
                style: .titleLarge,
              ),
              const Spacer(),
            ],
          ),
          FText(
            L10n.of(context).settings_image_mode_page__hint_2,
            style: .bodyLarge,
            textAlign: .start,
          ),
          FImageCard.maximized(
            coverSelector: (_) => image,
            imageType: FImageType.asset,
            width: 400,
          ),
        ],
      ),
    );
  }
}
