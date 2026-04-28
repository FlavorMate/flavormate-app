import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

import '../devices/ipad_pro.dart';
import '../devices/iphone_pro.dart';
import '../devices/macbook_pro.dart';

class UScreenshot {
  static void screenshot(
    String description, {
    required Locale locale,
    required Widget home,
    required AssetBundle assets,
    Color primaryColor = FLAVORMATE_COLOR,
    ThemeMode themeMode = .light,
    Future<void> Function(WidgetTester tester)? beforeScreenshot,
  }) {
    final devices = [
      iPhone17ProBuilder(assets),
      iPadProM513InchBuilder(assets),
      macBookProM516InchBuilder(assets),
    ];

    group(description, () {
      for (final device in devices) {
        testGoldens('for ${device.label}', (tester) async {
          await tester.pumpWidget(
            ScreenshotApp.withConditionalTitlebar(
              localizationsDelegates: L10n.localizationsDelegates,
              supportedLocales: L10n.supportedLocales,
              theme: FTheme.createTheme(
                primaryColor,
                .light,
                FlexTones.material,
              ),
              darkTheme: FTheme.createTheme(
                primaryColor,
                .dark,
                FlexTones.material,
              ),
              themeMode: themeMode,
              locale: locale,
              device: device.device,
              title: 'FlavorMate',
              home: home,
            ),
          );

          // One of our tests needs to interact with the UI before taking the screenshot.
          await beforeScreenshot?.call(tester);

          // Precache the images and fonts so they're ready for the screenshot.
          await tester.loadAssets();

          // Pump the widget for a second to ensure animations are complete.
          await tester.pumpFrames(
            tester.widget(find.byType(ScreenshotApp)),
            const Duration(seconds: 1),
          );

          // Take the screenshot and compare it to the golden file.
          await tester.expectScreenshot(
            device.device,
            description,
            langCode: locale.languageCode,
          );
        });
      }
    });
  }
}
