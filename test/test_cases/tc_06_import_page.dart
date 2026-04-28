import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers.dart';
import 'package:flavormate/presentation/features/recipe_import/recipe_import_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/import_export/import_export.dart';
import 'tc.dart';

class TC06ImportPage extends TC {
  const TC06ImportPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides {
    final plugins = ImportExport.getByOrder(
      locale,
      (a, b) => a.name.compareToIgnoreCase(b.name),
    );

    return [
      pIeImportersProvider.overrideWithBuild(
        (ref, it) => plugins,
      ),
    ];
  }

  @override
  void run() {
    screenshot(
      '6_import_page',
      const RecipeImportPage(),
    );
  }
}
