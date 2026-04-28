import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers_item.dart';
import 'package:flavormate/presentation/features/recipe_import_item/recipe_import_item_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/import_export/import_export.dart';
import 'tc.dart';

class TC07ImportItemPage extends TC {
  const TC07ImportItemPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides => [
    pIeImportersItemProvider.overrideWithBuild(
      (ref, it) => ImportExport.ie_flavormate[locale]!,
    ),
  ];

  @override
  void run() {
    screenshot(
      '7_import_item_page',
      RecipeImportItemPage(
        id: ImportExport.ie_flavormate[locale]!.id,
      ),
    );
  }
}
