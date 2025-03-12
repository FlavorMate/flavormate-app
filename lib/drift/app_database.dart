import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flavormate/drift/tables/draft_table.dart';
import 'package:flavormate/drift/tables/story_draft_table.dart';
import 'package:flavormate/extensions/e_drift.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DraftTable, StoryDraftTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(storyDraftTable);

          await m.addColumnIfNotExists(draftTable, draftTable.originId);
        }
      },
      beforeOpen: (OpeningDetails details) async {
        if (details.hadUpgrade) {
          if (details.versionNow == 2) {
            // Get all recipe drafts which is an update
            final drafts =
                await (draftTable.select()
                      ..where((draft) => draft.version.isBiggerOrEqualValue(0)))
                    .get();

            // since the id is the recipe id, set it to the originId
            for (final draft in drafts) {
              await (draftTable.update()).replace(
                DraftTableCompanion.insert(
                  id: Value(draft.id),
                  originId: Value(draft.id),
                  recipeDraft: draft.recipeDraft,
                  images: draft.images,
                  addedImages: draft.addedImages,
                  removedImages: draft.removedImages,
                  version: draft.version,
                ),
              );
            }
          }
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    final web = DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
      onResult: (result) {
        if (result.missingFeatures.isNotEmpty) {
          debugPrint(
            'Using ${result.chosenImplementation} due to unsupported '
            'browser features: ${result.missingFeatures}',
          );
        }
      },
    );
    return driftDatabase(name: 'my_database', web: web);
  }
}
