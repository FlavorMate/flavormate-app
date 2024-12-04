import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/library/p_book.dart';
import 'package:flavormate/riverpod/library/p_book_page.dart';
import 'package:flavormate/riverpod/library/p_book_recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookPage extends ConsumerWidget {
  final int id;
  final String? title;

  const BookPage({super.key, required this.id, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pBookProvider(id));
    return RScaffold(
      provider,
      appBar: TAppBar(title: title ?? L10n.of(context).p_book),
      floatingActionButton: (_, book) => !book.isOwner
          ? FloatingActionButton(
              onPressed: () => toggleSubscription(context, ref),
              child: Icon(
                book.isSubscribed ? MdiIcons.star : MdiIcons.starOutline,
              ),
            )
          : null,
      builder: (_, __) => TPageable(
        provider: pBookRecipesProvider(id),
        pageProvider: pBookPageProvider,
        onEmpty: TEmptyMessage(
          title: L10n.of(context).p_book_no_recipes,
          subtitle: L10n.of(context).p_book_no_recipes_subtitle,
          icon: MdiIcons.cookieOffOutline,
        ),
        builder: (_, page) => TWrap(
          children: [
            for (final recipe in page.content) TRecipeCard(recipe: recipe)
          ],
        ),
        onPressed: setPage,
      ),
    );
  }

  void setPage(WidgetRef ref, int value) {
    ref.read(pBookPageProvider.notifier).setState(value);
  }

  void toggleSubscription(BuildContext context, WidgetRef ref) async {
    context.showLoadingDialog();

    await ref.read(pBookProvider(id).notifier).toggleSubscription(id);

    if (!context.mounted) return;
    context.pop();
  }
}
