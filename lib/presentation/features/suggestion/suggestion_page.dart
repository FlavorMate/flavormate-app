import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_random.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/contents/f_paginated_content_card.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_content.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestionPage extends ConsumerStatefulWidget {
  final Course? course;

  const SuggestionPage({super.key, this.course});

  @override
  ConsumerState<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends ConsumerState<SuggestionPage> {
  final ScrollController _controller = ScrollController();

  Diet get _diet => ref.read(pRestAccountsSelfProvider).requireValue.diet;

  String get _title => switch (widget.course) {
    Course.MainDish => context.l10n.suggestion_page__title_cooking,
    Course.Bakery => context.l10n.suggestion_page__title_bakery,
    _ => context.l10n.suggestion_page__title,
  };

  PRestRecipesRandomProvider get provider => pRestRecipesRandomProvider(
    diet: _diet,
    course: widget.course,
    pageProviderId: PageableState.unused.name,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(title: _title),
      floatingActionButton: FloatingActionButton(
        onPressed: () => reset(ref),
        child: const Icon(MdiIcons.refresh),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            FPaginatedContent(
              provider: provider,
              pageProvider: pPageableStateProvider(PageableState.unused.name),
              controller: _controller,
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

            // Add some space so content doesn't overlap with FAB
            const FSizedBoxSliver(height: 56 + 32),
          ],
        ),
      ),
    );
  }

  void reset(WidgetRef ref) {
    ref.invalidate(provider);
    _controller.jumpTo(0);
  }
}
