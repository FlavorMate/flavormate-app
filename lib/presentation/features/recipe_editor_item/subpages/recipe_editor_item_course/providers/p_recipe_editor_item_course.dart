import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_course.g.dart';

@riverpod
class PRecipeEditorItemCourse extends _$PRecipeEditorItemCourse {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<Course?> build(String draftId) async {
    return await ref.watch(_parentProvider.selectAsync((it) => it.course));
  }

  Future<void> set(Course input) async {
    return await ref.read(_parentProvider.notifier).setCourse(input);
  }
}
