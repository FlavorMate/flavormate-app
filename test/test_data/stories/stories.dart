import 'dart:ui';

import 'package:flavormate/data/models/features/stories/story_dto.dart';

import '../recipe_files/recipe_files.dart';

class Stories {
  static final Map<Locale, StoryPreviewDto>
  s_b5b26f00_2f79_4eb8_9978_e86d29300dec = {
    const Locale('en'): const StoryPreviewDto(
      id: 'b5b26f00-2f79-4eb8-9978-e86d29300dec',
      label: 'A treat at every birthday party',
      cover: RecipeFiles.rf_b613c255_53da_4369_bb2e_b3477d2b1503,
    ),
    const Locale('de'): const StoryPreviewDto(
      id: 'b5b26f00-2f79-4eb8-9978-e86d29300dec',
      label: 'Ein Genuss auf jedem Geburtstag',
      cover: RecipeFiles.rf_b613c255_53da_4369_bb2e_b3477d2b1503,
    ),
  };
}
