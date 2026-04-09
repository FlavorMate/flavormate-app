import 'package:file_selector/file_selector.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';

class RecipeEditorScrapeDialogResult {
  final String pluginId;
  final IEImportType type;
  final List<String>? urls;
  final List<XFile>? files;

  const RecipeEditorScrapeDialogResult({
    required this.pluginId,
    required this.type,
    this.urls,
    this.files,
  });
}

enum RecipeEditorScrapeDialogResultType { Url, File }
