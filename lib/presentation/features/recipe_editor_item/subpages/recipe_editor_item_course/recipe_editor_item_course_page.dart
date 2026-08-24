import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/shape_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_course/providers/p_recipe_editor_item_course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class RecipeEditorItemCoursePage extends ConsumerStatefulWidget {
  const RecipeEditorItemCoursePage({super.key, required this.draftId});

  final String draftId;

  PRecipeEditorItemCourseProvider get provider =>
      pRecipeEditorItemCourseProvider(draftId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemCoursePageState();
}

class _RecipeEditorItemCoursePageState
    extends ConsumerState<RecipeEditorItemCoursePage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCourse = ref.watch(widget.provider).value;

    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: context.l10n.recipe_editor_item_course_page__title,
        actions: [
          FProgress(
            provider: widget.provider,
            color: context.colorScheme.onSurface,
            getProgress: (data) => data != null ? 1 : 0,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FConstrainedBoxSliver(
              maxWidth: FBreakpoint.smValue,
              padding: const .all(PADDING),
              sliver: SliverMainAxisGroup(
                slivers: [
                  FPageIntroductionSliver(
                    shape: ShapeConstants.editor,
                    icon: Symbols.grocery_rounded,
                    description: context
                        .l10n
                        .recipe_editor_item_course_page__description,
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  SliverToBoxAdapter(
                    child: FTileGroup(
                      items: [
                        for (final course in Course.values)
                          FTile(
                            leading: Icon(
                              selectedCourse == course
                                  ? Symbols.check_circle_rounded
                                  : Symbols.circle_rounded,
                              color: context.colorScheme.primary,
                            ),
                            label: course.getName(context),
                            onTap: () => set(course),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void set(Course input) async {
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).set(input);

    if (!mounted) return;
    context.pop();
  }
}
