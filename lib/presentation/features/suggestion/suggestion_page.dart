import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_random.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_content.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestionPage extends ConsumerWidget {
  final Course? course;
  final ScrollController controller = ScrollController();

  SuggestionPage({super.key, this.course});

  PRestRecipesRandomProvider get provider => pRestRecipesRandomProvider(
    diet: Diet.Meat,
    course: course,
    pageProviderId: PageableState.unused.name,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = switch (course) {
      Course.MainDish => L10n.of(context).suggestion_page__title_cooking,
      Course.Bakery => L10n.of(context).suggestion_page__title_bakery,
      _ => L10n.of(context).suggestion_page__title,
    };

    return FProviderPage(
      provider: provider,
      appBarBuilder: (_, _) => FAppBar(title: label),
      floatingActionButtonBuilder: (_, _) => FloatingActionButton(
        onPressed: () => reset(ref),
        child: const Icon(MdiIcons.refresh),
      ),
      builder: (_, data) => FPageableContent(
        controller: controller,
        child: FWrap(
          children: [
            for (final recipe in data.data)
              FImageCard.maximized(
                coverSelector: (resolution) => recipe.cover?.url(resolution),
                width: 400,
                label: recipe.label,
                onTap: () => context.routes.recipesItem(recipe.id),
              ),
            const SizedBox(height: 52),
          ],
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).suggestion_page__on_empty,
        icon: StateIconConstants.suggestions.errorIcon,
      ),
    );
  }

  void reset(WidgetRef ref) {
    ref.invalidate(provider);
    controller.jumpTo(0);
  }
}
