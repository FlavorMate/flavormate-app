import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsMiscSection extends ConsumerWidget {
  const SettingsMiscSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FCard(
      padding: PADDING,
      child: Column(
        spacing: PADDING,
        children: [
          FText(
            L10n.of(context).settings_misc_section__title,
            style: FTextStyle.headlineMedium,
          ),
          FIconButton(
            onPressed: () => context.routes.settingsTheme(),
            icon: MdiIcons.formatPaint,
            label: L10n.of(context).settings_misc_section__theme,
            width: BUTTON_WIDTH,
          ),
          FIconButton(
            onPressed: () => context.routes.settingsFullImage(),
            icon: MdiIcons.imageOutline,
            label: L10n.of(context).settings_misc_section__image_mode,
            width: BUTTON_WIDTH,
          ),
        ],
      ),
    );
  }
}
