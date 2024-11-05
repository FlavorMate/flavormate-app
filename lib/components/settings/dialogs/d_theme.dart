import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_scrollable_h.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flavormate/riverpod/theme/p_custom_color.dart';
import 'package:flavormate/riverpod/theme/p_dynamic_color.dart';
import 'package:flavormate/riverpod/theme/p_theme.dart';
import 'package:flavormate/riverpod/theme/p_theme_mode.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DTheme extends ConsumerStatefulWidget {
  const DTheme({super.key});

  static const colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DThemeState();
}

class _DThemeState extends ConsumerState<DTheme> {
  late Set<CustomThemeMode> _selection;
  Color _color = Colors.red;

  // values from shared preferences
  Color? _savedColor;
  DynamicColors? _dynamicColors;

  @override
  void initState() {
    // get current selection
    _selection = {ref.read(pThemeModeProvider)};

    // get system design
    _dynamicColors = ref.read(pDynamicColorProvider).requireValue;

    // get chosen color
    final colorInt = ref
        .read(pSharedPreferencesProvider)
        .requireValue
        .getInt('theme_custom_color');

    if (colorInt != null) {
      _savedColor = Color(colorInt);
    }

    if (_selection.single == CustomThemeMode.flavormate) {
      _color = FLAVORMATE_COLOR;
    } else if (_selection.single == CustomThemeMode.custom) {
      _color = _savedColor ?? Colors.red;
    }

    super.initState();
  }

  ThemeData get _theme {
    if (_selection.single == CustomThemeMode.dynamic) {
      if (Theme.of(context).brightness == Brightness.light) {
        return ThemeData(colorScheme: _dynamicColors!.light);
      } else {
        return ThemeData(colorScheme: _dynamicColors!.dark);
      }
    }
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _color,
        brightness: Theme.of(context).brightness,
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: TFullDialog(
        title: L10n.of(context).d_settings_theme_title,
        submit: setTheme,
        child: TColumn(
          children: [
            SegmentedButton<CustomThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: CustomThemeMode.flavormate,
                  label: Text(L10n.of(context).d_settings_theme_flavormate),
                ),
                ButtonSegment(
                  value: CustomThemeMode.custom,
                  label: Text(L10n.of(context).d_settings_theme_custom),
                ),
                if (_dynamicColors != null)
                  ButtonSegment(
                    value: CustomThemeMode.dynamic,
                    label: Text(L10n.of(context).d_settings_theme_system),
                  ),
              ],
              selected: _selection,
              onSelectionChanged: setMode,
            ),
            if (_selection.single == CustomThemeMode.flavormate)
              TColumn(
                space: PADDING * 2,
                children: [
                  TText(
                    L10n.of(context).d_settings_theme_flavormate_desc,
                    TextStyles.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const CircleAvatar(
                    radius: PADDING * 2,
                    backgroundColor: FLAVORMATE_COLOR,
                    foregroundColor: Colors.white,
                    child: Icon(MdiIcons.check),
                  ),
                ],
              ),
            if (_selection.single == CustomThemeMode.custom)
              TColumn(
                space: PADDING * 2,
                children: [
                  TText(
                    L10n.of(context).d_settings_theme_custom_desc,
                    TextStyles.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  TScrollableH(
                    child: TRow(
                      children: DTheme.colors.map((color) {
                        return GestureDetector(
                          onTap: () => setState(() => _color = color),
                          child: CircleAvatar(
                            radius: PADDING * 2,
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            child: _color.value == color.value
                                ? const Icon(MdiIcons.check)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            if (_selection.single == CustomThemeMode.dynamic)
              TColumn(
                space: PADDING * 2,
                children: [
                  TText(
                    L10n.of(context).d_settings_theme_system_desc,
                    TextStyles.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  CircleAvatar(
                    radius: PADDING * 2,
                    backgroundColor: _dynamicColors!.light!.inversePrimary,
                    foregroundColor: Colors.white,
                    child: const Icon(MdiIcons.check),
                  ),
                ],
              ),
            const Divider(),
            TColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TScrollableH(
                  child: TRow(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: Text(L10n.of(context).d_settings_theme_example),
                      ),
                      Slider(
                        value: 0.5,
                        onChanged: (_) {},
                      ),
                      Chip(
                          label:
                              Text(L10n.of(context).d_settings_theme_example)),
                    ],
                  ),
                ),
                TCard(
                  child: TColumn(
                    children: [
                      TText(
                        L10n.of(context).d_settings_theme_example,
                        TextStyles.headlineMedium,
                      ),
                      TIconButton(
                        onPressed: () {},
                        icon: MdiIcons.formatPaint,
                        label: L10n.of(context).d_settings_theme_example,
                      ),
                    ],
                  ),
                ),
                TRow(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Switch(value: false, onChanged: (_) {}),
                    Switch(value: true, onChanged: (_) {}),
                    Checkbox(value: false, onChanged: (_) {}),
                    Checkbox(value: true, onChanged: (_) {}),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(L10n.of(context).d_settings_theme_example),
                  ),
                ),
                TRow(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio(value: false, groupValue: null, onChanged: (_) {}),
                    Radio(value: true, groupValue: true, onChanged: (_) {}),
                    const CircularProgressIndicator(),
                    const SizedBox(width: 48, child: LinearProgressIndicator()),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setMode(Set<CustomThemeMode> mode) {
    if (mode.single == CustomThemeMode.flavormate) {
      setState(() {
        _color = FLAVORMATE_COLOR;
        _selection = mode;
      });
    } else if (mode.single == CustomThemeMode.custom) {
      setState(() {
        _color = _savedColor ?? Colors.red;
        _selection = mode;
      });
    } else if (mode.single == CustomThemeMode.dynamic) {
      setState(() {
        _color = Colors.red;
        _selection = mode;
      });
    }
  }

  void setTheme() async {
    if (_selection.single == CustomThemeMode.flavormate) {
      ref.read(pCustomColorProvider.notifier).setColor(null);
      ref.read(pThemeModeProvider.notifier).setMode(null);
    } else if (_selection.single == CustomThemeMode.custom) {
      ref.read(pCustomColorProvider.notifier).setColor(_color);
      ref.read(pThemeModeProvider.notifier).setMode(_selection.single);
    } else if (_selection.single == CustomThemeMode.dynamic) {
      ref.read(pCustomColorProvider.notifier).setColor(null);
      ref.read(pThemeModeProvider.notifier).setMode(_selection.single);
    }

    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) context.pop();
  }
}
