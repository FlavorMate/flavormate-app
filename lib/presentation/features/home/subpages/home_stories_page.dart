import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeStoriesPage extends ConsumerWidget {
  const HomeStoriesPage({super.key});

  PRestStoriesProvider get provider => pRestStoriesProvider(
    PageableState.storiesFull.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.storiesFull.name);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).home_stories_page__title),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: pageProvider,
          builder: (_, stories) => FWrap(
            children: [
              for (final story in stories)
                FImageCard.maximized(
                  label: story.label,
                  coverSelector: (resolution) => story.cover?.url(resolution),
                  width: 400,
                  onTap: () => context.routes.storiesItem(story.id),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).home_stories_page__on_empty,
            icon: StateIconConstants.stories.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).home_stories_page__on_error,
            icon: StateIconConstants.stories.errorIcon,
          ),
        ),
      ),
    );
  }
}
