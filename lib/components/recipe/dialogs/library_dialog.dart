import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/library/p_whole_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return TAlertDialog(
      height: 350,
      title: L10n.of(context).d_recipe_library_title,
      negativeLabel: L10n.of(context).btn_close,
      child: RStruct(
        provider,
        (_, page) => page.isNotEmpty
            ? ListView.builder(
                itemCount: page.length,
                itemBuilder: (_, index) {
                  final book = page[index];
                  return CheckboxListTile(
                    value: book.has(widget.recipe),
                    onChanged: (_) => toggleRecipeInBook(
                      book.id!,
                      widget.recipe.id!,
                    ),
                    title: Text(book.label),
                  );
                },
              )
            : TEmptyMessage(
                title: L10n.of(context).d_recipe_library_no_books,
                subtitle: L10n.of(context).d_recipe_library_no_books_subtitle,
                icon: MdiIcons.bookOffOutline,
              ),
      ),
    );
  }

  Future<void> toggleRecipeInBook(int bookId, int recipeId) async {
    return ref
        .read(pWholeLibraryProvider.notifier)
        .toggleRecipeInBook(bookId, recipeId);
  }
}
