import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemCoursePicker extends StatelessWidget {
  final Course? course;

  const RecipeEditorItemCoursePicker({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.recipe_editor_item_course_picker__title),
      scrollable: true,
      constraints: const BoxConstraints(
        minWidth: 560,
        maxWidth: 560,
      ),
      insetPadding: const .all(PADDING),
      content: FTileGroup(
        items: List.generate(Course.values.length, (index) {
          final item = Course.values[index];
          return FTile(
            label: item.getName(context),
            subLabel: null,
            leading: FTileIcon(
              iconBackgroundColor: Colors.transparent,
              icon: course == item
                  ? MdiIcons.checkCircleOutline
                  : MdiIcons.circleOutline,
            ),
            onTap: () => context.pop(item),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.btn_close),
        ),
      ],
    );
  }
}
