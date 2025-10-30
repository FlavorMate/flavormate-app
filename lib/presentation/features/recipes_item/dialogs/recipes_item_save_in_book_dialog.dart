import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_own.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flutter/material.dart';
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
  PRestBooksOwnProvider get provider => pRestBooksOwnProvider(
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      height: 450,
      title: L10n.of(context).recipes_item_save_in_book_dialog__title,
      negativeLabel: L10n.of(context).btn_close,
      child: FPageable(
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: const [OrderBy.Label, OrderBy.CreatedOn],
          padding: padding,
        ),
        padding: 0,
        provider: provider,
        pageProvider: widget.pageProvider,
        builder: (_, data) => Column(
          children: [
            for (final book in data)
              FutureBuilder(
                future: recipeInBook(book.id, widget.recipe.id),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    return CheckboxListTile(
                      value: asyncSnapshot.data,
                      onChanged: (_) =>
                          toggleRecipeInBook(book.id, widget.recipe.id),
                      title: Text(book.label),
                    );
                  } else if (asyncSnapshot.hasError) {
                    return ListTile(title: Text(book.label));
                  } else {
                    return ListTile(
                      title: Text(book.label),
                      trailing: const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
        onError: FEmptyMessage(
          title: L10n.of(context).recipes_item_save_in_book_dialog__on_error,
          icon: StateIconConstants.books.errorIcon,
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(
            context,
          ).recipes_item_save_in_book_dialog__on_empty,
          icon: StateIconConstants.books.emptyIcon,
        ),
      ),

      // FProviderStruct(
      //   provider: provider,
      //   builder: (_, books) => !books.isEmpty
      //       ? ListView.builder(
      //           itemCount: books.content.length,
      //           itemBuilder: (_, index) {
      //             final book = books.content.elementAt(index);
      //
      //             final recipeInBook = book.recipes!.content.any(
      //               (r) => r.id == recipe.id,
      //             );
      //
      //             return CheckboxListTile(
      //               value: recipeInBook,
      //               onChanged: (_) =>
      //                   toggleRecipeInBook(ref, book.id!, recipe.id),
      //               title: Text(book.label!),
      //             );
      //           },
      //         )
      //       : FEmptyMessage(
      //           title: L10n.of(
      //             context,
      //           ).recipes_item_save_in_book_dialog__on_empty,
      //           icon: StateIconConstants.books.emptyIcon,
      //         ),
      //   onError: FEmptyMessage(
      //     title: L10n.of(context).recipes_item_save_in_book_dialog__on_error,
      //     icon: StateIconConstants.books.errorIcon,
      //   ),
      // ),
    );
  }

  Future<bool> recipeInBook(String bookId, String recipeId) async {
    return await ref.read(provider.notifier).isRecipeInBook(bookId, recipeId);
  }

  Future<ApiResponse<void>> toggleRecipeInBook(
    String bookId,
    String recipeId,
  ) async {
    return await ref
        .read(provider.notifier)
        .toggleRecipeInBook(bookId, recipeId);
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
