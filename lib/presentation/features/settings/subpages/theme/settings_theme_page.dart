import 'package:flavormate/core/constants/color_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_custom_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_mode.dart';
import 'package:flavormate/core/theme/enums/f_theme_mode.dart';
import 'package:flavormate/core/theme/models/blended_colors.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flavormate/core/theme/providers/p_dynamic_color.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_scrollable_h.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/subpages/theme/widgets/settings_theme_color_card.dart';
import 'package:flavormate/presentation/features/settings/subpages/theme/widgets/settings_theme_section_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsThemePage extends ConsumerStatefulWidget {
  const SettingsThemePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeThemeDialogState();
}

class _ChangeThemeDialogState extends ConsumerState<SettingsThemePage> {
  late Set<FThemeMode> _selection;
  Color _color = Colors.red;

  // values from shared preferences
  Color? _savedColor;
  FTheme? _dynamicColors;

  @override
  void initState() {
    // get current selection
    _selection = {ref.read(pSPThemeModeProvider)!};

    // get system design
    _dynamicColors = ref.read(pDynamicColorProvider);

    // get chosen color
    final colorInt = ref
        .read(pSPProvider)
        .requireValue
        .getInt(SPKey.ThemeCustomColor.name);

    if (colorInt != null) {
      _savedColor = Color(colorInt);
    }

    if (_selection.single == FThemeMode.flavormate) {
      _color = FLAVORMATE_COLOR;
    } else if (_selection.single == FThemeMode.custom) {
      _color = _savedColor ?? Colors.red;
    }

    super.initState();
  }

  ThemeData get _theme {
    if (_selection.single == FThemeMode.dynamic) {
      if (Theme.of(context).brightness == Brightness.light) {
        return ThemeData(
          colorScheme: _dynamicColors!.light,
          extensions: [_dynamicColors!.lightBlendedColors],
          fontFamily: 'GoogleSansFlex',
        );
      } else {
        return ThemeData(
          colorScheme: _dynamicColors!.dark,
          extensions: [_dynamicColors!.darkBlendedColors],
          fontFamily: 'GoogleSansFlex',
        );
      }
    }
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _color,
        brightness: Theme.of(context).brightness,
      ),
      extensions: [BlendedColors.fromPrimary(_color)],
      fontFamily: 'GoogleSansFlex',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: Scaffold(
        appBar: FAppBar(
          title: L10n.of(context).settings_theme_page__title,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: setTheme,
          child: const Icon(MdiIcons.contentSave),
        ),
        body: SafeArea(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                SegmentedButton<FThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: .flavormate,
                      label: Text(L10n.of(context).flavormate),
                    ),
                    ButtonSegment(
                      value: .custom,
                      label: Text(
                        L10n.of(context).settings_theme_page__mode_custom,
                      ),
                    ),
                    if (_dynamicColors != null)
                      ButtonSegment(
                        value: .dynamic,
                        label: Text(
                          L10n.of(context).settings_theme_page__mode_system,
                        ),
                      ),
                  ],
                  selected: _selection,
                  onSelectionChanged: setMode,
                ),
                if (_selection.single == .flavormate)
                  Column(
                    spacing: PADDING * 2,
                    children: [
                      FText(
                        L10n.of(context).settings_theme_page__mode_default_hint,
                        style: .titleLarge,
                        textAlign: .center,
                      ),
                      const SizedBox(
                        height: 80,
                        child: Align(
                          alignment: .topCenter,
                          child: CircleAvatar(
                            radius: PADDING * 2,
                            backgroundColor: FLAVORMATE_COLOR,
                            foregroundColor: Colors.white,
                            child: Icon(MdiIcons.check),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_selection.single == .custom)
                  Column(
                    spacing: PADDING * 2,
                    children: [
                      FText(
                        L10n.of(context).settings_theme_page__mode_custom_hint,
                        style: .titleLarge,
                        textAlign: .center,
                      ),
                      SizedBox(
                        height: 80,
                        child: FScrollableH(
                          child: Row(
                            spacing: PADDING,
                            children: [
                              for (final color in ColorConstants.themeColors)
                                SettingsThemeColorCard(
                                  onTap: () => setState(() => _color = color),
                                  color: color,
                                  selected:
                                      _color.toARGB32() == color.toARGB32(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_selection.single == .dynamic)
                  Column(
                    spacing: PADDING * 2,
                    children: [
                      FText(
                        L10n.of(context).settings_theme_page__mode_system_hint,
                        style: .titleLarge,
                        textAlign: .center,
                      ),
                      SizedBox(
                        height: 80,
                        child: Align(
                          alignment: .topCenter,
                          child: CircleAvatar(
                            radius: PADDING * 2,
                            backgroundColor:
                                _dynamicColors!.light!.inversePrimary,
                            foregroundColor: Colors.white,
                            child: const Icon(MdiIcons.check),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Divider(),
                const SettingsThemeSectionExample(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setMode(Set<FThemeMode> mode) {
    if (mode.single == .flavormate) {
      setState(() {
        _color = FLAVORMATE_COLOR;
        _selection = mode;
      });
    } else if (mode.single == .custom) {
      setState(() {
        _color = _savedColor ?? Colors.red;
        _selection = mode;
      });
    } else if (mode.single == .dynamic) {
      setState(() {
        _color = Colors.red;
        _selection = mode;
      });
    }
  }

  void setTheme() async {
    if (_selection.single == .flavormate) {
      await ref.read(pSPThemeCustomColorProvider.notifier).setColor(null);
      await ref.read(pSPThemeModeProvider.notifier).setMode(_selection.single);
    } else if (_selection.single == .custom) {
      await ref.read(pSPThemeCustomColorProvider.notifier).setColor(_color);
      await ref.read(pSPThemeModeProvider.notifier).setMode(_selection.single);
    } else if (_selection.single == .dynamic) {
      await ref.read(pSPThemeCustomColorProvider.notifier).setColor(null);
      await ref.read(pSPThemeModeProvider.notifier).setMode(_selection.single);
    }

    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) context.pop();
  }
}
