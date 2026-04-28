import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_exporters.dart';
import 'package:flavormate/presentation/features/recipe_export/recipe_export_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/import_export/import_export.dart';
import 'tc.dart';

class TC08ExportPage extends TC {
  const TC08ExportPage({
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
      pIeExportersProvider.overrideWithBuild(
        (ref, it) => plugins,
      ),
    ];
  }

  @override
  void run() {
    screenshot(
      '8_export_page',
      const RecipeExportPage(),
    );
  }
}
