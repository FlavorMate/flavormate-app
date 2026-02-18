import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_random.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sliver_list.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_side_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
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
  final ScrollController _scrollController = ScrollController();

  Diet get _diet => ref.read(pRestAccountsSelfProvider).requireValue.diet;

  String get _title => switch (widget.course) {
    Course.MainDish => context.l10n.suggestion_page__title_cooking,
    Course.Bakery => context.l10n.suggestion_page__title_bakery,
    _ => context.l10n.suggestion_page__title,
  };

  String get _description => switch (widget.course) {
    .MainDish => context.l10n.suggestion_page__hint__main_dish,
    .Bakery => context.l10n.suggestion_page__hint__bakery,
    _ => '',
  };

  IconData get _icon => switch (widget.course) {
    .MainDish => MdiIcons.pasta,
    .Bakery => MdiIcons.cupcake,
    _ => MdiIcons.potSteam,
  };

  PRestRecipesRandomProvider get provider => pRestRecipesRandomProvider(
    diet: _diet,
    course: widget.course,
    pageProviderId: PageableState.unused.name,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: _title,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => reset(ref),
        child: const Icon(MdiIcons.refresh),
      ),
      body: SafeArea(
        child: FProviderState(
          provider: provider,
          onEmpty: FEmptyMessage(
            title: context.l10n.suggestion_page__on_empty,
            icon: StateIconConstants.suggestions.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: context.l10n.suggestion_page__on_empty,
            icon: StateIconConstants.suggestions.errorIcon,
          ),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              FConstrainedBoxSliver(
                maxWidth: FBreakpoint.smValue,
                padding: const .all(PADDING),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    FPageIntroductionSliver(
                      shape: .sunny,
                      icon: _icon,
                      description: _description,
                    ),

                    const FSizedBoxSliver(height: PADDING),

                    FSliverList(
                      provider: provider,
                      pageProvider: pPageableStateProvider(
                        PageableState.unused.name,
                      ),
                      scrollController: _scrollController,
                      itemBuilder: (item, index, first, last) =>
                          FContentSideCard(
                            title: item.label,
                            imageSelector: item.cover?.url,
                            onTap: () => context.routes.recipesItem(item.id),
                            first: first,
                            last: last,
                          ),
                    ),
                  ],
                ),
              ),
              // Add some space so content doesn't overlap with FAB
              const FSizedBoxSliver(height: kFabHeight),
            ],
          ),
        ),
      ),
    );
  }

  void reset(WidgetRef ref) {
    ref.invalidate(provider);
  }
}
