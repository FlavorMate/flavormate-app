import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_own.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesItemSaveInBookDialog extends ConsumerStatefulWidget {
  final CommonRecipe recipe;

  const RecipesItemSaveInBookDialog({super.key, required this.recipe});

  String get pageProviderId => PageableState.recipeAddBook.name;

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<RecipesItemSaveInBookDialog> createState() =>
      _RecipesItemSaveInBookDialogState();
}

class _RecipesItemSaveInBookDialogState
    extends ConsumerState<RecipesItemSaveInBookDialog>
    with FOrderMixin<RecipesItemSaveInBookDialog> {
  final _scrollController = ScrollController();

  PRestBooksOwnProvider get provider => pRestBooksOwnProvider(
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      height: 450,
      scrollable: false,
      title: context.l10n.recipes_item_save_in_book_dialog__title,
      negativeLabel: context.l10n.btn_close,
      actions: [
        TextButton.icon(
          onPressed: handleFilterDialog,
          label: Text(context.l10n.btn_filter),
          icon: const Icon(MdiIcons.filter),
        ),
      ],
      child: FProviderState(
        provider: provider,
        onError: FEmptyMessage(
          title: context.l10n.recipes_item_save_in_book_dialog__on_error,
          icon: StateIconConstants.books.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: context.l10n.recipes_item_save_in_book_dialog__on_empty,
          icon: StateIconConstants.books.emptyIcon,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FLazySliverList(
              key: orderKey,
              provider: provider,
              pageProvider: widget.pageProvider,
              scrollController: _scrollController,
              itemBuilder: (item, index, first, last) {
                return FutureBuilder(
                  future: recipeInBook(item.id, widget.recipe.id),
                  builder: (_, data) {
                    if (!data.hasData) {
                      return FTile.manual(
                        first: first,
                        last: last,
                        tile: FTile(
                          disabled: true,
                          leading: const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          ),
                          label: item.label,
                          subLabel: context.l10n
                              .categories_page__recipe_counter(
                                item.recipeCount,
                              ),
                          onTap: () {},
                        ),
                      );
                    }

                    return FTile.manual(
                      first: first,
                      last: last,
                      tile: FTile(
                        leading: Icon(
                          data.data == true
                              ? MdiIcons.checkboxMarked
                              : MdiIcons.checkboxBlankOutline,
                          color: context.colorScheme.primary,
                        ),
                        label: item.label,
                        subLabel: context.l10n.categories_page__recipe_counter(
                          item.recipeCount,
                        ),
                        onTap: () =>
                            toggleRecipeInBook(item.id, widget.recipe.id),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> recipeInBook(String bookId, String recipeId) async {
    return await ref.read(provider.notifier).isRecipeInBook(bookId, recipeId);
  }

  Future<void> toggleRecipeInBook(
    String bookId,
    String recipeId,
  ) async {
    await ref.read(provider.notifier).toggleRecipeInBook(bookId, recipeId);

    resetLazyList(() => ref.read(widget.pageProvider.notifier).reset());
  }

  void handleFilterDialog() async {
    final result = await openFilterDialog();
    if (result != null) {
      ref.read(widget.pageProvider.notifier).reset();
    }
  }

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.book;

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
