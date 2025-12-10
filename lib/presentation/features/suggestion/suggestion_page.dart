import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_random.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/contents/f_paginated_content_card.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_content.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
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
      Course.MainDish => context.l10n.suggestion_page__title_cooking,
      Course.Bakery => context.l10n.suggestion_page__title_bakery,
      _ => context.l10n.suggestion_page__title,
    };

    return Scaffold(
      appBar: FAppBar(title: label),
      floatingActionButton: FloatingActionButton(
        onPressed: () => reset(ref),
        child: const Icon(MdiIcons.refresh),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            FPaginatedContent(
              provider: provider,
              pageProvider: pPageableStateProvider(PageableState.unused.name),
              controller: controller,
              onEmpty: FEmptyMessage(
                title: context.l10n.suggestion_page__on_empty,
                icon: StateIconConstants.suggestions.emptyIcon,
              ),
              onError: FEmptyMessage(
                title: context.l10n.suggestion_page__on_empty,
                icon: StateIconConstants.suggestions.errorIcon,
              ),
              itemBuilder: (items) => FPaginatedContentCard(
                data: items,
                itemBuilder: (item) => FImageCard.maximized(
                  coverSelector: (resolution) => item.cover?.url(resolution),
                  label: item.label,
                  onTap: () => context.routes.recipesItem(item.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reset(WidgetRef ref) {
    ref.invalidate(provider);
    controller.jumpTo(0);
  }
}
