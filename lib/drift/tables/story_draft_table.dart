import 'package:drift/drift.dart';
import 'package:flavormate/models/recipe/recipe.dart';

class StoryDraftTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text().nullable()();

  TextColumn get content => text().nullable()();

  TextColumn get recipe => text().map(const RecipeConverter()).nullable()();

  IntColumn get version => integer().withDefault(const Constant(0))();
}

// stores recipe as string
class RecipeConverter extends TypeConverter<Recipe, String> {
  const RecipeConverter();

  @override
  Recipe fromSql(String fromDb) {
    return RecipeMapper.fromJson(fromDb);
  }

  @override
  String toSql(Recipe value) {
    return value.toJson();
  }
}
