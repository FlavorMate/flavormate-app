import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_custom_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_tone.dart';
import 'package:flavormate/core/theme/providers/p_dynamic_color.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/theme/settings_app_theme_page.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tc.dart';

class TC05SettingsAppThemePage extends TC {
  const TC05SettingsAppThemePage({
    required super.locale,
    required super.assets,
  });

  @override
  Color get primaryColor => Colors.pink;

  @override
  List<Override> get overrides => [
    pSPThemeToneProvider.overrideWithValue(.vivid),
    // Sets mode to user selected color
    pSPThemeModeProvider.overrideWithValue(.custom),
    // Mocks the system theme color
    pDynamicColorProvider.overrideWithValue(Colors.orange),
    // Mocks the user selected color
    pSPThemeCustomColorProvider.overrideWithValue(primaryColor),
  ];

  @override
  void run() {
    screenshot(
      '5_theme',
      const SettingsAppThemePage(),
    );
  }
}
