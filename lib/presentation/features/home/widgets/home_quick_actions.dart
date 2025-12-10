import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_random.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_card.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeQuickActions extends ConsumerWidget {
  static const double _size = 125;

  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemSize = _size;

        const max = 4 * _size + 3 * PADDING;
        const min = 2 * _size + 1 * PADDING;

        if (constraints.maxWidth <= max && constraints.maxWidth >= min) {
          itemSize = (constraints.maxWidth / 2) - PADDING;
        }

        return FWrap(
          children: [
            SizedBox(
              width: itemSize,
              child: Align(
                alignment: Alignment.centerRight,
                child: FIconCard(
                  height: _size,
                  width: _size,
                  icon: MdiIcons.pasta,
                  label: context.l10n.home_quick_actions__cooking,
                  onTap: () => openSuggestion(context, course: Course.MainDish),
                ),
              ),
            ),
            SizedBox(
              width: itemSize,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FIconCard(
                  height: _size,
                  width: _size,
                  icon: MdiIcons.cupcake,
                  label: context.l10n.home_quick_actions__baking,
                  onTap: () => openSuggestion(context, course: Course.Bakery),
                ),
              ),
            ),
            SizedBox(
              width: itemSize,
              child: Align(
                alignment: Alignment.centerRight,
                child: FIconCard(
                  height: _size,
                  width: _size,
                  icon: MdiIcons.diceMultiple,
                  label: context.l10n.home_quick_actions__random,
                  onTap: () => openRecipe(context, ref),
                ),
              ),
            ),
            SizedBox(
              width: itemSize,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FIconCard(
                  height: _size,
                  width: _size,
                  icon: MdiIcons.bookOpen,
                  label: context.l10n.home_quick_actions__all_recipes,
                  onTap: () => context.routes.recipes(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> openSuggestion(BuildContext context, {Course? course}) async {
    return context.routes.suggestion(course);
  }

  Future<void> openRecipe(
    BuildContext context,
    WidgetRef ref, {
    Course? course,
  }) async {
    try {
      final diet = await ref.read(
        pRestAccountsSelfProvider.selectAsync((data) => data.diet),
      );

      final response = await ref.read(
        pRestRecipesRandomProvider(
          diet: diet,
          course: course,
          pageProviderId: PageableState.unused.name,
          pageSize: 1,
        ).future,
      );

      if (!context.mounted) return;
      await context.routes.recipesItem(response.data.first.id);
    } catch (e) {
      if (!context.mounted) return;
      context.showTextSnackBar(
        context.l10n.home_quick_actions__no_recipe_available,
      );
    }
  }
}
