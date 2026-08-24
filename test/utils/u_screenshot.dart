import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_ui/material_ui.dart';

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
    final lightTheme = FTheme.createTheme(
      primaryColor,
      .light,
      FlexTones.material,
    );

    final darkTheme = FTheme.createTheme(
      primaryColor,
      .dark,
      FlexTones.material,
    );

    final m3eTheme = switch (themeMode) {
      .light => M3EThemeData.fromMaterial(lightTheme),
      .dark => M3EThemeData.fromMaterial(darkTheme),
      _ => throw UnimplementedError(),
    };

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
              localizationsDelegates: const [
                L10n.delegate,
                ...GlobalMaterialLocalizations.delegates,
              ],
              supportedLocales: L10n.supportedLocales,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              locale: locale,
              device: device.device,
              title: 'FlavorMate',
              home: M3ETheme(data: m3eTheme, child: home),
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
