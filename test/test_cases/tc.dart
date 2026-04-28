import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_input_type/f_input_type_aware_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/u_screenshot.dart';

abstract class TC {
  final Locale locale;
  final AssetBundle assets;
  final Color primaryColor;
  final ThemeMode themeMode;

  const TC({
    required this.locale,
    required this.assets,
    this.primaryColor = FLAVORMATE_COLOR,
    this.themeMode = .light,
  });

  List<Override> get overrides;

  void run();

  void screenshot(
    String name,
    Widget child, {
    Future<void> Function(WidgetTester)? beforeScreenshot,
  }) {
    UScreenshot.screenshot(
      name,
      locale: locale,
      home: FInputTypeAwareApp(
        child: ProviderScope(
          overrides: overrides,
          child: child,
        ),
      ),
      assets: assets,
      primaryColor: primaryColor,
      themeMode: themeMode,
      beforeScreenshot: beforeScreenshot,
    );
  }
}
