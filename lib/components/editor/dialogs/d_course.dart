import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DCourse extends StatelessWidget {
  final Course? course;

  const DCourse({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.of(context).d_editor_course_title),
      content: SizedBox(
        width: 250,
        child: TColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final course in Course.values)
              TButton(
                onPressed: () => context.pop(course),
                leading: Icon(course.icon),
                label: course.getName(context),
                trailing: this.course == course
                    ? const Icon(MdiIcons.checkCircleOutline)
                    : null,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(L10n.of(context).btn_cancel),
        ),
      ],
    );
  }
}
