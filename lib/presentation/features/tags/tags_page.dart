import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/tags/p_rest_tags.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/contents/f_paginated_content_card.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagsPage extends ConsumerStatefulWidget {
  const TagsPage({super.key});

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.tags.name);

  @override
  ConsumerState<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends ConsumerState<TagsPage>
    with FOrderMixin<TagsPage> {
  PRestTagsProvider get provider => pRestTagsProvider(
    PageableState.tags.name,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: context.l10n.tags_page__title,
      provider: provider,
      pageProvider: widget.pageProvider,
      onEmpty: FEmptyMessage(
        title: context.l10n.tags_page__on_empty,
        icon: StateIconConstants.tags.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: context.l10n.tags_page__on_error,
        icon: StateIconConstants.tags.emptyIcon,
      ),
      sortBuilder: () => FPaginatedSort(
        currentOrderBy: orderBy,
        currentDirection: orderDirection,
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
        options: OrderByConstants.tag,
      ),
      itemBuilder: (items) => FPaginatedContentCard(
        data: items,
        itemBuilder: (item) => FImageCard.maximized(
          label: item.label,
          coverSelector: (resolution) => item.cover?.url(resolution),
          subLabel: context.l10n.tags_page__recipe_counter(item.recipeCount),
          onTap: () => context.routes.tagsItem(item.id),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
