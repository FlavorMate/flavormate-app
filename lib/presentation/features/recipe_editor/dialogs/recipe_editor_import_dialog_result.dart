import 'package:file_selector/file_selector.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';

class RecipeEditorImportDialogResult {
  final String pluginId;
  final IEImportType type;
  final List<String>? urls;
  final List<XFile>? files;

  const RecipeEditorImportDialogResult({
    required this.pluginId,
    required this.type,
    this.urls,
    this.files,
  });
}

enum RecipeEditorImportDialogResultType { Url, File }
