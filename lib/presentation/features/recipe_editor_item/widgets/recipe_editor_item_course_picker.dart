import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemCoursePicker extends StatelessWidget {
  final Course? course;

  const RecipeEditorItemCoursePicker({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.recipe_editor_item_course_picker__title,
      child: Column(
        spacing: PADDING,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final course in Course.values)
            FButton(
              onPressed: () => context.pop(course),
              leading: Icon(course.icon),
              label: course.getName(context),
              trailing: this.course == course
                  ? const Icon(MdiIcons.checkCircleOutline)
                  : null,
            ),
        ],
      ),
    );
  }
}
