import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';

part 'common_category.mapper.dart';

@MappableClass()
class CommonCategory with CommonCategoryMappable {
  final String id;
  final String label;

  const CommonCategory({
    required this.id,
    required this.label,
  });

  factory CommonCategory.fromDraft(CategoryDto draft) {
    return CommonCategory(
      id: draft.id,
      label: draft.label,
    );
  }

  factory CommonCategory.fromRecipe(CategoryDto recipe) {
    return CommonCategory(
      id: recipe.id,
      label: recipe.label,
    );
  }
}
