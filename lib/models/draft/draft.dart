import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';

part 'draft.mapper.dart';

@MappableClass()
class Draft with DraftMappable {
  final int id;
  final int? originId;
  final RecipeDraft recipeDraft;
  final List<File> images;
  final List<File> addedImages;
  final List<File> removedImages;
  final int version;

  Draft({
    required this.id,
    required this.originId,
    required this.recipeDraft,
    required this.images,
    required this.addedImages,
    required this.removedImages,
    required this.version,
  });

  factory Draft.fromDB(DraftTableData data) {
    return Draft(
      id: data.id,
      originId: data.originId,
      recipeDraft: data.recipeDraft,
      images: data.images,
      addedImages: data.addedImages,
      removedImages: data.removedImages,
      version: data.version,
    );
  }

  List<File> get displayImages {
    final list = images
        .where((image) =>
            removedImages.indexWhere((rI) => image.id == rI.id) == -1)
        .toList();
    list.addAll(addedImages);
    return list;
  }

  double get imagesProgress {
    var score = 0.0;

    if (displayImages.isNotEmpty) score += 100;

    return score;
  }

  bool get isValid {
    return [
      recipeDraft.commonProgress >= 100,
      recipeDraft.durationProgress >= 100,
      recipeDraft.ingredientsProgress >= 100,
      recipeDraft.instructionsProgress >= 100,
      recipeDraft.courseProgress >= 100,
      recipeDraft.dietProgress >= 100,
    ].every((value) => value == true);
  }
}
