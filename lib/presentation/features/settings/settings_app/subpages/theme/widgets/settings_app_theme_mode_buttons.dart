import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/theme/enums/f_theme_tone.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
            fontWeight: .w500,
            color: .primary,
          ),
          SizedBox(
            width: double.infinity,
            child: M3ESegmentedButton(
              onSelectionChanged: setTone,
              showSelectedIcon: false,
              segments: [
                M3ESegment(
                  value: FThemeTone.material,
                  label: FThemeTone.material.l10n(context),
                  icon: const Icon(Symbols.brush_rounded),
                ),
                M3ESegment(
                  value: FThemeTone.vivid,
                  label: FThemeTone.vivid.l10n(context),
                  icon: const Icon(Symbols.imagesearch_roller_rounded),
                ),
                M3ESegment(
                  value: FThemeTone.chroma,
                  label: FThemeTone.chroma.l10n(context),
                  icon: const Icon(Symbols.palette_rounded),
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
