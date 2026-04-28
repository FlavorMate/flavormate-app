/// This file contains the tests that take screenshots of the app.
///
/// Run it with `flutter test --update-goldens` to generate the screenshots
/// or `flutter test` to compare the screenshots to the golden files.
library;

import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_exporters.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_exporters_item.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/presentation/features/recipe_export/recipe_export_page.dart';
import 'package:flavormate/presentation/features/recipe_export_item/recipe_export_item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_cases/tc_00_recipe_item_page.dart';
import 'test_cases/tc_01_home_page.dart';
import 'test_cases/tc_02_library_page.dart';
import 'test_cases/tc_03_recipe_editor_page.dart';
import 'test_cases/tc_04_settings_account_diet_page.dart';
import 'test_cases/tc_05_settings_app_theme_page.dart';
import 'test_cases/tc_06_import_page.dart';
import 'test_cases/tc_07_import_item_page.dart';
import 'test_cases/tc_08_export_page.dart';
import 'test_cases/tc_09_export_item_page.dart';
import 'test_data/import_export/import_export.dart';
import 'test_data/recipes/recipes.dart';
import 'utils/disk_asset_bundle.dart';
import 'utils/u_screenshot.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assets = await DiskAssetBundle.loadFromPath('test/_resources/');

  group('Screenshot ENG:', () {
    const locale = Locale('en');
    TC00RecipeItemPage(locale: locale, assets: assets).run();
    TC01HomePage(locale: locale, assets: assets).run();
    TC02LibraryPage(locale: locale, assets: assets).run();
    TC03RecipeEditorPage(locale: locale, assets: assets).run();
    TC04SettingsAccountDietPage(locale: locale, assets: assets).run();
    TC05SettingsAppThemePage(locale: locale, assets: assets).run();
    TC06ImportPage(locale: locale, assets: assets).run();
    TC07ImportItemPage(locale: locale, assets: assets).run();
    TC08ExportPage(locale: locale, assets: assets).run();
    TC09ExportItemPage(locale: locale, assets: assets).run();
  });

  group('Screenshot DE:', () {
    const locale = Locale('de');
    TC00RecipeItemPage(locale: locale, assets: assets).run();
    TC01HomePage(locale: locale, assets: assets).run();
    TC02LibraryPage(locale: locale, assets: assets).run();
    TC03RecipeEditorPage(locale: locale, assets: assets).run();
    TC04SettingsAccountDietPage(locale: locale, assets: assets).run();
    TC05SettingsAppThemePage(locale: locale, assets: assets).run();
    TC06ImportPage(locale: locale, assets: assets).run();
    TC07ImportItemPage(locale: locale, assets: assets).run();
    TC08ExportPage(locale: locale, assets: assets).run();
    TC09ExportItemPage(locale: locale, assets: assets).run();
  });
}
