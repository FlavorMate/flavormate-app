import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/shape_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_own.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class RecipesItemSaveInBookDialog extends ConsumerStatefulWidget {
  final CommonRecipe recipe;

  const RecipesItemSaveInBookDialog({super.key, required this.recipe});

  static Future<void> openDialog(
    BuildContext context, {
    required CommonRecipe recipe,
  }) async {
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => RecipesItemSaveInBookDialog(recipe: recipe),
    );
  }

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
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(
          title: context.l10n.recipes_item_save_in_book_dialog__title,
          scrollController: _scrollController,
        ),
        body: SafeArea(
          child: FProviderState(
            provider: provider,
            onError: FEmptyMessage(
              title: context.l10n.recipes_item_save_in_book_dialog__on_error,
              icon: IconConstants.errorIcon,
            ),
            onEmpty: FEmptyMessage(
              title: context.l10n.recipes_item_save_in_book_dialog__on_empty,
              icon: IconConstants.emptyIcon,
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
                        shape: ShapeConstants.secondLevel,
                        icon: Symbols.bookmark_add_rounded,
                        description: context
                            .l10n
                            .recipes_item_save_in_book_dialog__description,
                      ),

                      const FSizedBoxSliver(height: PADDING),

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
                                  context: context,
                                  disabled: true,
                                  tile: FTile(
                                    disabled: true,
                                    leading: const Icon(
                                      Symbols.circle_rounded,
                                      color: Colors.grey,
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
                                context: context,
                                tile: FTile(
                                  leading: Icon(
                                    data.data == true
                                        ? Symbols.check_circle_rounded
                                        : Symbols.circle_rounded,
                                    color: context.colorScheme.primary,
                                  ),
                                  label: item.label,
                                  subLabel: context.l10n
                                      .categories_page__recipe_counter(
                                        item.recipeCount,
                                      ),
                                  onTap: () => toggleRecipeInBook(
                                    item.id,
                                    widget.recipe.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return FAlertDialog(
      scrollable: false,
      title: context.l10n.recipes_item_save_in_book_dialog__title,
      negativeLabel: context.l10n.btn_close,
      actions: [
        M3EButton.icon(
          style: .tonal,
          onPressed: handleFilterDialog,
          label: Text(context.l10n.btn_filter),
          icon: const Icon(Symbols.filter_alt_rounded),
        ),
      ],
      child: ConstrainedBox(
        constraints: const .new(maxHeight: 250),
        child: FProviderState(
          provider: provider,
          onError: FEmptyMessage(
            title: context.l10n.recipes_item_save_in_book_dialog__on_error,
            icon: IconConstants.errorIcon,
          ),
          onEmpty: FEmptyMessage(
            title: context.l10n.recipes_item_save_in_book_dialog__on_empty,
            icon: IconConstants.emptyIcon,
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
                          context: context,
                          disabled: true,
                          tile: FTile(
                            disabled: true,
                            leading: const Icon(
                              Symbols.circle_rounded,
                              color: Colors.grey,
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
                        context: context,
                        tile: FTile(
                          leading: Icon(
                            data.data == true
                                ? Symbols.check_circle_rounded
                                : Symbols.circle_rounded,
                            color: context.colorScheme.primary,
                          ),
                          label: item.label,
                          subLabel: context.l10n
                              .categories_page__recipe_counter(
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
