import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe/ingredients/ingredient_group.dart';
import 'package:flavormate/models/recipe/instructions/instruction_group.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flavormate/models/tag/tag.dart';

part 'recipe.mapper.dart';

@MappableClass()
class Recipe extends Entity with RecipeMappable {
  String label;

  List<File> files;
  Author? author;
  String? description;
  double rating;

  Duration prepTime;

  Duration cookTime;

  Duration restTime;

  Serving serving;
  List<InstructionGroup> instructionGroups;

  List<IngredientGroup> ingredientGroups;

  List<Book>? books;
  List<Category>? categories;
  List<Tag>? tags;
  Course course;
  Diet diet;
  Uri? url;
  String publicUrl;
  String? coverUrl;

  // Constructor
  Recipe({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.author,
    required this.tags,
    required this.books,
    required this.categories,
    required this.files,
    required this.label,
    required this.rating,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.serving,
    required this.instructionGroups,
    required this.ingredientGroups,
    required this.course,
    required this.diet,
    required this.publicUrl,
    required this.coverUrl,
    this.description,
    this.url,
  });

  RecipeDraft toDraft() {
    return RecipeDraft(
      categories: categories?.map((c) => c.id!).toList() ?? [],
      ingredientGroups: ingredientGroups.map((iG) => iG.toDraft()).toList(),
      instructionGroups: instructionGroups.map((iG) => iG.toDraft()).toList(),
      serving: serving.toDraft(),
      tags: tags?.map((tag) => tag.toDraft()).toList() ?? [],
      cookTime: cookTime,
      prepTime: prepTime,
      restTime: restTime,
      course: course,
      diet: diet,
      description: description,
      label: label,
      url: url.toString(),
    );
  }
}
