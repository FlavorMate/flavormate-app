import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_serving_dto.dart';

import '../accounts/accounts.dart';

class RecipeDrafts {
  static final rd_0 = RecipeDraftFullDto(
    id: 'id',
    version: 0,
    createdOn: DateTime.now(),
    lastModifiedOn: DateTime.now(),
    label: null,
    originId: null,
    ownedBy: AccountPreviews.aThenus,
    description: null,
    prepTime: Duration.zero,
    cookTime: Duration.zero,
    restTime: Duration.zero,
    serving: const RecipeDraftServingDto(
      id: 'id',
      amount: null,
      label: null,
    ),
    ingredientGroups: const [],
    instructionGroups: const [],
    categories: const [],
    tags: const [],
    course: null,
    diet: null,
    url: null,
    files: const [],
  );
}
