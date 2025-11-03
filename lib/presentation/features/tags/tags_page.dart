import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/tags/p_rest_tags.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
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
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).tags_page__title),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: widget.pageProvider,
          filterBuilder: (padding) => FPageableSort(
            currentOrderBy: orderBy,
            currentDirection: orderDirection,
            setOrderBy: setOrderBy,
            setOrderDirection: setOrderDirection,
            options: OrderByConstants.tag,
            padding: padding,
          ),
          builder: (_, data) => FWrap(
            children: [
              for (final tag in data)
                FImageCard.maximized(
                  label: tag.label,
                  coverSelector: (resolution) => tag.cover?.url(resolution),
                  width: 400,
                  subLabel: L10n.of(
                    context,
                  ).tags_page__recipe_counter(tag.recipeCount),
                  onTap: () => context.routes.tagsItem(tag.id),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).tags_page__on_empty,
            icon: StateIconConstants.tags.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).tags_page__on_error,
            icon: StateIconConstants.tags.emptyIcon,
          ),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
