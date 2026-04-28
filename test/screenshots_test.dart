/// This file contains the tests that take screenshots of the app.
///
/// Run it with `flutter test --update-goldens` to generate the screenshots
/// or `flutter test` to compare the screenshots to the golden files.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_cases/tc_10_search_page.dart';
import 'utils/disk_asset_bundle.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assets = await DiskAssetBundle.loadFromPath('test/_resources/');

  group('Screenshot ENG:', () {
    const locale = Locale('en');
    // TC00RecipeItemPage(locale: locale, assets: assets).run();
    // TC01HomePage(locale: locale, assets: assets).run();
    // TC02LibraryPage(locale: locale, assets: assets).run();
    // TC03RecipeEditorPage(locale: locale, assets: assets).run();
    // TC04SettingsAccountDietPage(locale: locale, assets: assets).run();
    // TC05SettingsAppThemePage(locale: locale, assets: assets).run();
    // TC06ImportPage(locale: locale, assets: assets).run();
    // TC07ImportItemPage(locale: locale, assets: assets).run();
    // TC08ExportPage(locale: locale, assets: assets).run();
    // TC09ExportItemPage(locale: locale, assets: assets).run();
    TC10SearchPage(locale: locale, assets: assets).run();
  });

  group('Screenshot DE:', () {
    const locale = Locale('de');
    // TC00RecipeItemPage(locale: locale, assets: assets).run();
    // TC01HomePage(locale: locale, assets: assets).run();
    // TC02LibraryPage(locale: locale, assets: assets).run();
    // TC03RecipeEditorPage(locale: locale, assets: assets).run();
    // TC04SettingsAccountDietPage(locale: locale, assets: assets).run();
    // TC05SettingsAppThemePage(locale: locale, assets: assets).run();
    // TC06ImportPage(locale: locale, assets: assets).run();
    // TC07ImportItemPage(locale: locale, assets: assets).run();
    // TC08ExportPage(locale: locale, assets: assets).run();
    // TC09ExportItemPage(locale: locale, assets: assets).run();
    TC10SearchPage(locale: locale, assets: assets).run();
  });
}
