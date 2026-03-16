import 'package:file_selector/file_selector.dart';
import 'package:flavormate/data/models/shared/enums/language.dart';

class RecipeEditorScrapeDialogResult {
  final RecipeEditorScrapeDialogResultType type;
  final String? url;
  final XFile? file;
  final Language? language;

  const RecipeEditorScrapeDialogResult({
    required this.type,
    this.url,
    this.file,
    this.language,
  });
}

enum RecipeEditorScrapeDialogResultType { Url, File }
