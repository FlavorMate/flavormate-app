import 'package:file_selector/file_selector.dart';

class RecipeEditorScrapeDialogResult {
  final RecipeEditorScrapeDialogResultType type;
  final String? url;
  final XFile? file;

  const RecipeEditorScrapeDialogResult({
    required this.type,
    this.url,
    this.file,
  });
}

enum RecipeEditorScrapeDialogResultType { Url, File }
