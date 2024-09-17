import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/models/draft/draft.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/drift/p_drift.dart';
import 'package:flavormate/riverpod/recipes/p_recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/u_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_drafts.g.dart';

@riverpod
class PDrafts extends _$PDrafts {
  @override
  Future<List<Draft>> build() async {
    final response =
        await (ref.watch(pDriftProvider).draftTable.select()).get();

    return response.map((data) => Draft.fromDB(data)).toList();
  }

  Future<int> scrape(String url) async {
    final response = await ref.read(pApiProvider).recipesClient.scrape(url);

    List<File> files = [];

    for (var image in response.images) {
      final base64 = UImage.resizeImage(
          bytes: base64Decode(image), width: 1280, height: 720);

      final file = File(
        id: Random().nextInt(1000),
        type: 'IMAGE',
        category: 'RECIPE',
        owner: -1,
        content: base64,
      );

      files.add(file);
    }

    final draft = DraftTableCompanion(
      recipeDraft: Value(response.recipe),
      images: const Value([]),
      addedImages: Value(files),
      removedImages: const Value([]),
      version: const Value(0),
    );

    final id = await ref.read(pDriftProvider).draftTable.insert().insert(draft);
    ref.invalidateSelf();
    return id;
  }

  Future<int> createDraft() async {
    final response = await ref.read(pDriftProvider).draftTable.insert().insert(
          DraftTableCompanion(
            recipeDraft: Value(RecipeDraft.empty()),
            images: const Value([]),
            addedImages: const Value([]),
            removedImages: const Value([]),
            version: const Value(0),
          ),
        );

    ref.invalidateSelf();
    return response;
  }

  Future<bool> deleteDraft(int id) async {
    await ref
        .read(pDriftProvider)
        .draftTable
        .deleteWhere((draft) => draft.id.isValue(id));

    ref.invalidateSelf();
    return true;
  }

  Future<int?> recipeToDraft(String id) async {
    final exists = await (ref.read(pDriftProvider).draftTable.select()
          ..where((d) => d.id.isValue(int.parse(id))))
        .getSingleOrNull();

    if (exists != null) return null;

    final recipe = await ref.read(pRecipeProvider(int.parse(id)).future);

    final server = ref.read(pServerProvider);

    final List<File> images = [];

    for (final image in recipe.files) {
      final url = image.path(server);
      String base64 = await ref.read(pApiProvider).filesClient.downloadRaw(url);
      base64 = 'data:image/jpeg;base64,$base64';

      images.add(
        File(
          id: image.id!,
          type: image.type,
          category: image.category,
          owner: image.owner,
          content: base64,
        ),
      );
    }

    final response = await ref.read(pDriftProvider).draftTable.insert().insert(
          DraftTableCompanion(
            id: Value(recipe.id!),
            recipeDraft: Value(recipe.toDraft()),
            images: Value(images),
            addedImages: const Value([]),
            removedImages: const Value([]),
            version: Value(recipe.version!),
          ),
        );

    ref.invalidateSelf();
    return response;
  }
}
