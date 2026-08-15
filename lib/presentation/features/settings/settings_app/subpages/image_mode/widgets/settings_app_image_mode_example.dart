import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/image_mode.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class SettingsAppImageModeExample extends StatelessWidget {
  final String label;
  final String hint;
  final String image;
  final ImageMode value;
  final bool state;
  final void Function(ImageMode) onTap;

  const SettingsAppImageModeExample({
    super.key,
    required this.label,
    required this.hint,
    required this.image,
    required this.value,
    required this.state,
    required this.onTap,
  });

  IconData get _icon =>
      state ? Symbols.check_circle_rounded : Symbols.circle_rounded;

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
                label,
                style: .titleLarge,
              ),
              const Spacer(),
            ],
          ),
          FText(
            hint,
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
