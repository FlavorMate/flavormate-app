import 'package:flavormate/core/constants/color_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_custom_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_tone.dart';
import 'package:flavormate/core/theme/enums/f_theme_mode.dart';
import 'package:flavormate/core/theme/enums/f_theme_tone.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flavormate/core/theme/providers/p_dynamic_color.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/theme/widgets/settings_app_theme_mode_buttons.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/theme/widgets/settings_app_theme_tile.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/theme/widgets/settings_app_theme_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAppThemePage extends ConsumerStatefulWidget {
  const SettingsAppThemePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAppThemePageState();
}

class _SettingsAppThemePageState extends ConsumerState<SettingsAppThemePage> {
  late FThemeMode _themeMode;
  late FThemeMode _activeThemeMode;
  late FThemeTone _themeTone;
  late Color _activeColor;
  late final Color? _deviceThemeColor;

  @override
  void initState() {
    // get current selection
    _themeTone = ref.read(pSPThemeToneProvider);
    _themeMode = ref.read(pSPThemeModeProvider);
    _activeThemeMode = _themeMode;

    // get system design
    _deviceThemeColor = ref.read(pDynamicColorProvider);

    final savedColor = ref.read(pSPThemeCustomColorProvider);

    if (_themeMode == .dynamic && _deviceThemeColor != null) {
      _activeColor = _deviceThemeColor;
    } else {
      _activeColor = savedColor;
    }

    super.initState();
  }

  ThemeData get _theme => FTheme.createTheme(
    _activeColor,
    Theme.brightnessOf(context),
    _themeTone.tone,
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: Scaffold(
        appBar: FAppBar(title: context.l10n.settings_app_theme_page__title),
        floatingActionButton: FloatingActionButton(
          onPressed: setTheme,
          child: const Icon(MdiIcons.contentSave),
        ),
        body: SafeArea(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                SettingsAppThemeModeButtons(
                  selected: _themeTone,
                  onTap: setTone,
                ),

                SettingsAppThemeTileList(
                  title: context.l10n.settings_app_theme_page__special_colors,
                  values: [
                    SettingsAppThemeTileData(
                      isSelected: _activeColor.isColor(
                        MiscColor.flavormate.color,
                      ),
                      color: MiscColor.flavormate.color,
                      label: context.l10n.flavormate,
                      onTap: setColor,
                    ),
                    if (_deviceThemeColor != null)
                      SettingsAppThemeTileData(
                        isSelected: _activeThemeMode == .dynamic,
                        color: _deviceThemeColor,
                        label: context.l10n.color__device_specific,
                        onTap: (color) => setColor(color, themeMode: .dynamic),
                      ),
                  ],
                ),

                SettingsAppThemeTileList(
                  title: context.l10n.settings_app_theme_page__default_colors,
                  values: DefaultColor.values
                      .map(
                        (it) => SettingsAppThemeTileData(
                          isSelected: _activeColor.isColor(it.color),
                          color: it.color,
                          label: it.l10n(context),
                          onTap: setColor,
                        ),
                      )
                      .toList(),
                ),

                SettingsAppThemeTileList(
                  title: context.l10n.settings_app_theme_page__event_colors,
                  values: EventColor.values
                      .map(
                        (it) => SettingsAppThemeTileData(
                          isSelected: _activeColor.isColor(it.color),
                          color: it.color,
                          label: it.l10n(context),
                          onTap: setColor,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setTheme() async {
    // Set theme mode
    await ref.read(pSPThemeModeProvider.notifier).setMode(_activeThemeMode);
    await ref.read(pSPThemeToneProvider.notifier).setMode(_themeTone);

    // If dynamic, set default color, else set user specified color
    if (_activeThemeMode == .dynamic) {
      await ref
          .read(pSPThemeCustomColorProvider.notifier)
          .setColor(MiscColor.flavormate.color);
    } else {
      await ref
          .read(pSPThemeCustomColorProvider.notifier)
          .setColor(_activeColor);
    }

    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) context.pop();
  }

  void setColor(Color color, {FThemeMode themeMode = .custom}) => setState(() {
    _activeColor = color;
    _activeThemeMode = themeMode;
  });

  void setTone(FThemeTone tone) => setState(() => _themeTone = tone);
}
