import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/library/p_book.dart';
import 'package:flavormate/riverpod/library/p_book_page.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  final int id;
  final String? title;

  const BookPage({super.key, required this.id, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: title ?? L10n.of(context).p_book),
      body: SafeArea(
        child: TPageable(
          provider: pBookProvider(id),
          pageProvider: pBookPageProvider,
          builder: (_, page) => TWrap(
            children: page.content
                .map((recipe) => TRecipeCard(recipe: recipe))
                .toList(),
          ),
          onPressed: (ref, value) =>
              ref.read(pBookPageProvider.notifier).setState(value),
        ),
      ),
    );
  }
}
