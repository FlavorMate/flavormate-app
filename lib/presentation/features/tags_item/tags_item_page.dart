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
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
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
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(title: data.label),
      builder: (_, data) => FPageable(
        provider: recipeProvider,
        pageProvider: widget.recipePageProvider,
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: OrderByConstants.recipe,
          padding: padding,
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(context).tags_item_page__recipe_on_empty,
          icon: StateIconConstants.tags.emptyIcon,
        ),
        onError: FEmptyMessage(
          title: L10n.of(context).tags_item_page__recipe_on_error,
          icon: StateIconConstants.tags.errorIcon,
        ),
        builder: (_, recipes) => FWrap(
          children: [
            for (final recipe in recipes)
              FImageCard.maximized(
                label: recipe.label,
                subLabel: recipe.totalTime.beautify(context),
                coverSelector: (resolution) => recipe.cover?.url(resolution),
                width: 400,
                onTap: () => context.routes.recipesItem(recipe.id),
              ),
          ],
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).tags_item_page__on_error,
        icon: StateIconConstants.tags.errorIcon,
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
