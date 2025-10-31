import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_id_recipes.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_menu_anchor.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/library_item/dialogs/edit_book_dialog.dart';
import 'package:flavormate/presentation/features/library_item/providers/p_library_item.dart';
import 'package:flavormate/presentation/features/library_item/widgets/library_item_info_header.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(
        title: data.book.label,
        actions: [
          FMenuAnchor(
            children: [
              if (data.isOwner || data.isAdmin)
                MenuItemButton(
                  child: Text(
                    data.book.visible
                        ? L10n.of(context).library_item_page__unshare
                        : L10n.of(context).library_item_page__share,
                  ),
                  onPressed: () =>
                      toggleVisibility(context, ref, !data.book.visible),
                ),
              if (data.isOwner || data.isAdmin)
                MenuItemButton(
                  child: Text(L10n.of(context).btn_edit),
                  onPressed: () => changeLabel(context, ref, data.book.label),
                ),
              if (data.isOwner || data.isAdmin)
                MenuItemButton(
                  child: Text(L10n.of(context).btn_delete),
                  onPressed: () => deleteBook(context, ref),
                ),
            ],
          ),
        ],
      ),
      builder: (_, data) => Column(
        spacing: PADDING,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: PADDING,
              left: PADDING,
              right: PADDING,
            ),
            child: LibraryItemInfoHeader(book: data.book),
          ),
          if (!data.isOwner)
            Center(
              child: SizedBox(
                width: BUTTON_WIDTH,
                child: FButton(
                  onPressed: () => toggleSubscription(context, ref),
                  label: data.isSubscribed
                      ? L10n.of(context).library_item_page__unfollow
                      : L10n.of(context).library_item_page__follow,
                ),
              ),
            ),
          Expanded(
            child: FPageable(
              onEmpty: FEmptyMessage(
                title: L10n.of(context).library_item_page__recipes_on_empty,
                icon: StateIconConstants.recipes.emptyIcon,
              ),
              onError: FEmptyMessage(
                title: L10n.of(context).library_item_page__recipes_on_error,
                icon: StateIconConstants.recipes.errorIcon,
              ),
              provider: recipeProvider,
              pageProvider: widget.pageRecipeProvider,
              filterBuilder: (padding) => FPageableSort(
                currentOrderBy: orderBy,
                currentDirection: orderDirection,
                setOrderBy: setOrderBy,
                setOrderDirection: setOrderDirection,
                options: const [
                  OrderBy.Label,
                  OrderBy.CreatedOn,
                ],
                padding: padding,
              ),
              builder: (_, data2) => FWrap(
                children: [
                  for (final recipe in data2)
                    FImageCard.maximized(
                      label: recipe.label,
                      subLabel: recipe.totalTime.beautify(context),
                      coverSelector: (resolution) =>
                          recipe.cover?.url(resolution),
                      onTap: () => context.routes.recipesItem(recipe.id),
                      width: 400,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).library_item_page__on_error,
        icon: StateIconConstants.books.errorIcon,
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
        L10n.of(context).library_item_page__edit_book_success,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).library_item_page__edit_book_failure,
      );
    }
  }

  Future<void> deleteBook(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(context).library_item_page__delete_book,
      ),
    );

    if (!context.mounted || response != true) return;

    context.showLoadingDialog();

    final result = await ref.read(widget.provider.notifier).deleteBook();

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        L10n.of(context).library_item_page__delete_book_success,
      );
      context.pop();
    } else {
      context.showTextSnackBar(
        L10n.of(context).library_item_page__delete_book_failure,
      );
    }
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
