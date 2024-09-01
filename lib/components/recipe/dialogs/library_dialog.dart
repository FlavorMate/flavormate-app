import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/library/p_whole_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryDialog extends ConsumerStatefulWidget {
  final Recipe recipe;

  const LibraryDialog({super.key, required this.recipe});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryDialogState();
}

class _LibraryDialogState extends ConsumerState<LibraryDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pWholeLibraryProvider);
    return AlertDialog(
      title: Text(L10n.of(context).d_recipe_library_title),
      content: SizedBox(
        height: 300,
        width: 250,
        child: RStruct(
            provider,
            (_, page) => ListView.builder(
                  itemCount: page.page.totalElements,
                  itemBuilder: (_, index) {
                    final book = page.content[index];
                    return CheckboxListTile(
                      value: book.has(widget.recipe),
                      onChanged: (_) => toggleRecipeInBook(
                        book.id!,
                        widget.recipe.id!,
                      ),
                      title: Text(book.label),
                    );
                  },
                )),
      ),
      actions: [
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(L10n.of(context).btn_close),
        ),
      ],
    );
  }

  Future<void> toggleRecipeInBook(int bookId, int recipeId) async {
    return ref
        .read(pWholeLibraryProvider.notifier)
        .toggleRecipeInBook(bookId, recipeId);
  }
}
