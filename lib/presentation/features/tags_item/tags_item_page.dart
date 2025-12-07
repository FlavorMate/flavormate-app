import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/tags/p_rest_tags_id.dart';
import 'package:flavormate/data/repositories/features/tags/p_rest_tags_id_recipes.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagsItemPage extends ConsumerStatefulWidget {
  final String id;

  const TagsItemPage({required this.id, super.key});

  PRestTagsIdProvider get provider => pRestTagsIdProvider(id);

  PPageableStateProvider get recipePageProvider =>
      pPageableStateProvider(PageableState.tagRecipes.getId(id));

  @override
  ConsumerState<TagsItemPage> createState() => _TagsItemPageState();
}

class _TagsItemPageState extends ConsumerState<TagsItemPage>
    with FOrderMixin<TagsItemPage> {
  PRestTagsIdRecipesProvider get recipeProvider => pRestTagsIdRecipesProvider(
    widget.id,
    PageableState.tagRecipes.getId(widget.id),
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    final tag = ref.watch(widget.provider);
    return FPaginatedPage(
      title: tag.value?.label ?? '',
      provider: recipeProvider,
      pageProvider: widget.recipePageProvider,
      onEmpty: FEmptyMessage(
        title: L10n.of(context).tags_item_page__recipe_on_empty,
        icon: StateIconConstants.tags.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).tags_item_page__recipe_on_error,
        icon: StateIconConstants.tags.errorIcon,
      ),
      sortBuilder: () => FPaginatedSort(
        currentOrderBy: orderBy,
        currentDirection: orderDirection,
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
        options: OrderByConstants.recipe,
      ),
      itemBuilder: (item) => FImageCard.maximized(
        label: item.label,
        subLabel: item.totalTime.beautify(context),
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.recipesItem(item.id),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
