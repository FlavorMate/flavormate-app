import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flavormate/drift/tables/draft_table.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DraftTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }
}
