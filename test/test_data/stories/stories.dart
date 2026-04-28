import 'dart:ui';

import 'package:flavormate/data/models/features/stories/story_dto.dart';

import '../recipe_files/recipe_files.dart';

class Stories {
  static final Map<Locale, StoryPreviewDto> sRocherCake = {
    const Locale('en'): const StoryPreviewDto(
      id: 'b5b26f00-2f79-4eb8-9978-e86d29300dec',
      label: 'A treat at every birthday party',
      cover: RecipeFiles.rfRocherCake,
    ),
    const Locale('de'): const StoryPreviewDto(
      id: 'b5b26f00-2f79-4eb8-9978-e86d29300dec',
      label: 'Ein Genuss auf jedem Geburtstag',
      cover: RecipeFiles.rfRocherCake,
    ),
  };
}
