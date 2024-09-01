import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuickActions extends ConsumerWidget {
  static const double _buttonWidth = 250;

  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 16,
      spacing: 16,
      children: [
        TIconButton(
          width: _buttonWidth,
          icon: MdiIcons.pasta,
          onPressed: () => toRecipe(context, ref, course: Course.MainDish),
          label: L10n.of(context).c_dashboard_quick_actions_cook,
        ),
        TIconButton(
          width: _buttonWidth,
          icon: MdiIcons.cupcake,
          onPressed: () => toRecipe(context, ref, course: Course.Bakery),
          label: L10n.of(context).c_dashboard_quick_actions_bake,
        ),
        TIconButton(
          width: _buttonWidth,
          icon: MdiIcons.diceMultiple,
          onPressed: () => toRecipe(context, ref),
          label: L10n.of(context).c_dashboard_quick_actions_random,
        ),
        TIconButton(
          icon: MdiIcons.bookOpen,
          onPressed: () => context.pushNamed('recipes'),
          label: L10n.of(context).c_dashboard_quick_actions_all,
          width: _buttonWidth,
        ),
      ],
    );
  }

  toRecipe(BuildContext context, WidgetRef ref, {Course? course}) async {
    final user = await ref.read(pUserProvider.selectAsync((data) => data));

    final recipe = await ref
        .read(pApiProvider)
        .recipesClient
        .findRandom(diet: user.diet!, course: course);

    await context.pushNamed(
      'recipe',
      pathParameters: {'id': '${recipe[0].id}'},
      extra: recipe[0].label,
    );
  }
}
