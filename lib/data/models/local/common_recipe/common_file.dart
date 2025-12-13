import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';

part 'common_file.mapper.dart';

@MappableClass()
class CommonFile with CommonFileMappable {
  final String id;
  final String path;

  const CommonFile({
    required this.id,
    required this.path,
  });

  factory CommonFile.fromDraft(RecipeDraftFileDto draft) {
    return CommonFile(
      id: draft.id,
      path: draft.path,
    );
  }

  factory CommonFile.fromRecipe(RecipeFileDto recipe) {
    return CommonFile(
      id: recipe.id,
      path: recipe.path,
    );
  }

  String url(ImageResolution resolution) =>
      '$path?resolution=${resolution.name}';

  String publicUrl(ImageResolution resolution) => '${url(resolution)}/public';
}
