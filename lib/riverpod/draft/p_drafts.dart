import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/models/draft/draft.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/drift/p_drift.dart';
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
    final image = UImage.resizeImage(
        bytes: base64Decode(response.image), width: 1280, height: 720);

    final file = File(
      id: Random().nextInt(1000),
      type: 'IMAGE',
      category: 'RECIPE',
      owner: -1,
      content: image,
      fileName: 'thumbnail.jpg',
    );

    final draft = DraftTableCompanion(
      recipeDraft: Value(response.recipe),
      images: const Value([]),
      addedImages: Value([file]),
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
}
