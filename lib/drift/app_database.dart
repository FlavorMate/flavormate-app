import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flavormate/drift/tables/draft_table.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DraftTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    final web = DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
      onResult: (result) {
        if (result.missingFeatures.isNotEmpty) {
          debugPrint('Using ${result.chosenImplementation} due to unsupported '
              'browser features: ${result.missingFeatures}');
        }
      },
    );
    return driftDatabase(name: 'my_database', web: web);
  }
}
