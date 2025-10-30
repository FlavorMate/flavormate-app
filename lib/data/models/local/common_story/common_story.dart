import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';

class CommonStory {
  final String id;
  final String label;
  final String content;
  final RecipePreviewDto recipe;
  final AccountPreviewDto ownedBy;

  final RecipeFileDto? cover;

  const CommonStory(
    this.id,
    this.label,
    this.content,
    this.recipe,
    this.ownedBy,
    this.cover,
  );

  factory CommonStory.fromDraft(StoryDraftFullDto draft) {
    return CommonStory(
      draft.id,
      draft.label!,
      draft.content!,
      draft.recipe!,
      draft.ownedBy,
      draft.cover,
    );
  }

  factory CommonStory.fromStory(StoryFullDto draft) {
    return CommonStory(
      draft.id,
      draft.label,
      draft.content,
      draft.recipe,
      draft.ownedBy,
      draft.cover,
    );
  }

  bool get hasCover => cover != null;
}
