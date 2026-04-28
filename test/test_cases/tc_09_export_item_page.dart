import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_exporters_item.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/presentation/features/recipe_export_item/recipe_export_item_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/import_export/import_export.dart';
import '../test_data/recipes/recipes.dart';
import '../utils/u_pageable.dart';
import 'tc.dart';

class TC09ExportItemPage extends TC {
  const TC09ExportItemPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides {
    final recipes = RecipePreviews.getByOrder(
      locale,
      (a, b) => a.label.compareToIgnoreCase(b.label),
    );

    return [
      pIeExportersItemProvider.overrideWithBuild(
        (ref, it) => ImportExport.ie_flavormate[locale]!,
      ),
      pRestRecipesProvider.overrideWithBuild(
        (ref, it) => UPageableDto.fromTestData(recipes),
      ),
    ];
  }

  @override
  void run() {
    screenshot(
      '9_export_item_page',
      RecipeExportItemPage(
        id: ImportExport.ie_flavormate[locale]!.id,
      ),
    );
  }
}
