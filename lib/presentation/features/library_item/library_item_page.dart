import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/constants/order_by_constants.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
        icon: IconConstants.errorIcon,
      ),
      builder: (context, data) => Scaffold(
        appBar: FAppBar(
          title: data.book.label,
          scrollController: _scrollController,
          actions: [
            M3EIconButton(
              icon: const Icon(Symbols.filter_alt_rounded),
              onPressed: handleFilterDialog,
            ),

            if (data.isOwner || data.isAdmin)
              FMenuAnchor(
                children: [
                  M3EMenuEntry(
                    leading: const Icon(Symbols.share_rounded),
                    label: data.book.visible
                        ? context.l10n.library_item_page__unshare
                        : context.l10n.library_item_page__share,
                    onPressed: () =>
                        toggleVisibility(context, ref, !data.book.visible),
                  ),
                  M3EMenuEntry(
                    leading: const Icon(Symbols.edit_rounded),
                    label: context.l10n.btn_edit,
                    onPressed: () => changeLabel(context, ref, data.book.label),
                  ),
                  M3EMenuEntry(
                    leading: const Icon(Symbols.delete_rounded),
                    label: context.l10n.btn_delete,
                    onPressed: () => deleteBook(context, ref),
                    isDestructive: true,
                  ),
                ],
              ),
          ],
        ),
        floatingActionButton: data.isOwner
            ? null
            : M3EExtendedFab(
                label: data.isSubscribed
                    ? context.l10n.library_item_page__unsubscribe
                    : context.l10n.library_item_page__subscribe,
                icon: Icon(
                  data.isSubscribed
                      ? Symbols.heart_minus_rounded
                      : Symbols.heart_plus_rounded,
                ),
                onPressed: () => toggleSubscription(context, ref),
              ),
        body: SafeArea(
          child: FProviderState(
            onEmpty: FEmptyMessage(
              title: context.l10n.library_item_page__recipes_on_empty,
              icon: IconConstants.emptyIcon,
            ),
            onError: FEmptyMessage(
              title: context.l10n.library_item_page__recipes_on_error,
              icon: IconConstants.errorIcon,
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

                      // Padding to prevent fab hiding items
                      if (!data.isOwner)
                        const FSizedBoxSliver(height: kFabHeight + PADDING),
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
    final response = await EditBookDialog.openDialog(context, label: current);

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
    final response = await openConfirmDialog(
      context,
      title: context.l10n.library_item_page__delete_book,
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
