import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_settings_image_mode.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class SettingsFullImageExample extends StatelessWidget {
  final String label;
  final String image;
  final Function(SpSettingsImageMode) onTap;
  final SpSettingsImageMode value;
  final bool state;

  const SettingsFullImageExample({
    super.key,
    required this.label,
    required this.image,
    required this.onTap,
    required this.value,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Column(
          spacing: PADDING / 2,
          children: [
            FImageCard.maximized(
              coverSelector: (_) => image,
              imageType: FImageType.asset,
              onTap: () => onTap(value),
            ),
            Row(
              spacing: PADDING / 2,
              mainAxisAlignment: .center,
              children: [
                Checkbox(value: state, onChanged: (_) => onTap(value)),
                FText(label, style: .bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
