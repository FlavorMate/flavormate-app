import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/theme/enums/f_theme_tone.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsAppThemeModeButtons extends StatelessWidget {
  final FThemeTone selected;
  final void Function(FThemeTone) onTap;

  Set<FThemeTone> get _selected => {selected};

  const SettingsAppThemeModeButtons({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 2,
        crossAxisAlignment: .start,
        children: [
          FText(
            context.l10n.settings_app_theme_page__color_mode,
            style: .bodyMedium,
            weight: .w500,
            color: .primary,
          ),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton(
              onSelectionChanged: setTone,
              segments: [
                ButtonSegment(
                  value: FThemeTone.Material,
                  label: Text(FThemeTone.Material.l10n(context)),
                  icon: const Icon(MdiIcons.brush),
                ),
                ButtonSegment(
                  value: FThemeTone.Vivid,
                  label: Text(FThemeTone.Vivid.l10n(context)),
                  icon: const Icon(MdiIcons.paletteSwatch),
                ),
                ButtonSegment(
                  value: FThemeTone.Chroma,
                  label: Text(FThemeTone.Chroma.l10n(context)),
                  icon: const Icon(MdiIcons.palette),
                ),
              ],
              selected: _selected,
            ),
          ),
        ],
      ),
    );
  }

  void setTone(Set<FThemeTone> set) {
    onTap(set.first);
  }
}
