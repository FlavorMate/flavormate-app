import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_id_recipes.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_content_side_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_menu_anchor.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_state.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/features/library_item/dialogs/edit_book_dialog.dart';
import 'package:flavormate/presentation/features/library_item/providers/p_library_item.dart';
import 'package:flavormate/presentation/features/library_item/widgets/library_item_info_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryItemPage extends ConsumerStatefulWidget {
  final String id;

  const LibraryItemPage({super.key, required this.id});

  PLibraryItemProvider get provider => pLibraryItemProvider(id);

  String get pageProviderId => PageableState.bookRecipes.getId(id);

  PPageableStateProvider get pageRecipeProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<LibraryItemPage> createState() => _LibraryItemPageState();
}

class _LibraryItemPageState extends ConsumerState<LibraryItemPage>
    with FOrderMixin<LibraryItemPage> {
  PRestBooksIdRecipesProvider get recipeProvider => pRestBooksIdRecipesProvider(
    bookId: widget.id,
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: widget.provider,
      onError: FEmptyMessage(
        title: context.l10n.library_item_page__on_error,
        icon: StateIconConstants.books.errorIcon,
      ),
      builder: (context, data) => Scaffold(
        appBar: FAppBar(
          title: data.book.label,
          scrollController: _scrollController,
          actions: [
            IconButton(
              icon: const Icon(MdiIcons.filter),
              onPressed: handleFilterDialog,
            ),

            if (data.isOwner || data.isAdmin)
              FMenuAnchor(
                children: [
                  MenuItemButton(
                    child: Text(
                      data.book.visible
                          ? context.l10n.library_item_page__unshare
                          : context.l10n.library_item_page__share,
                    ),
                    onPressed: () =>
                        toggleVisibility(context, ref, !data.book.visible),
                  ),
                  MenuItemButton(
                    child: Text(context.l10n.btn_edit),
                    onPressed: () => changeLabel(context, ref, data.book.label),
                  ),
                  MenuItemButton(
                    child: Text(context.l10n.btn_delete),
                    onPressed: () => deleteBook(context, ref),
                  ),
                ],
              ),
          ],
        ),
        body: SafeArea(
          child: FProviderState(
            onEmpty: FEmptyMessage(
              title: context.l10n.library_item_page__recipes_on_empty,
              icon: StateIconConstants.recipes.emptyIcon,
            ),
            onError: FEmptyMessage(
              title: context.l10n.library_item_page__recipes_on_error,
              icon: StateIconConstants.recipes.errorIcon,
            ),
            provider: recipeProvider,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                FConstrainedBoxSliver(
                  maxWidth: FBreakpoint.smValue,
                  padding: const .all(PADDING),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: LibraryItemInfoHeader(book: data.book),
                      ),

                      const FSizedBoxSliver(height: PADDING),

                      FLazySliverList(
                        key: orderKey,
                        provider: recipeProvider,
                        pageProvider: widget.pageRecipeProvider,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleSubscription(BuildContext context, WidgetRef ref) async {
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).subscribeToBook();

    if (!context.mounted) return;
    context.pop();
  }

  Future<void> toggleVisibility(
    BuildContext context,
    WidgetRef ref,
    bool visible,
  ) async {
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).setVisibility(visible);

    if (!context.mounted) return;
    context.pop();
  }

  Future<void> changeLabel(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final response = await showDialog<String>(
      context: context,
      builder: (_) => EditBookDialog(label: current),
    );

    if (!context.mounted || response == null || response == current) return;

    context.showLoadingDialog();

    final result = await ref.read(widget.provider.notifier).setLabel(response);

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        context.l10n.library_item_page__edit_book_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.library_item_page__edit_book_failure,
      );
    }
  }

  Future<void> deleteBook(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context.l10n.library_item_page__delete_book,
      ),
    );

    if (!context.mounted || response != true) return;

    context.showLoadingDialog();

    final result = await ref.read(widget.provider.notifier).deleteBook();

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        context.l10n.library_item_page__delete_book_success,
      );
      context.pop();
    } else {
      context.showTextSnackBar(
        context.l10n.library_item_page__delete_book_failure,
      );
    }
  }

  void handleFilterDialog() async {
    final result = await openFilterDialog();
    if (result != null) {
      ref.read(widget.pageRecipeProvider.notifier).reset();
    }
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;

  @override
  List<OrderBy> get allowedFilters => OrderByConstants.recipe;
}
