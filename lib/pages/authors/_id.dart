import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/authors/p_author.dart';
import 'package:flavormate/riverpod/authors/p_author_page.dart';
import 'package:flutter/material.dart';

class AuthorPage extends StatelessWidget {
  final int id;
  final String? title;

  const AuthorPage({required this.id, super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: title ?? L10n.of(context).p_author),
      body: SafeArea(
        child: TPageable(
          provider: pAuthorProvider(id),
          pageProvider: pAuthorPageProvider,
          builder: (_, recipes) => TWrap(
            children: recipes.content
                .map((recipe) => TRecipeCard(recipe: recipe))
                .toList(),
          ),
          onPressed: (ref, value) =>
              ref.read(pAuthorPageProvider.notifier).setState(value),
        ),
      ),
    );
  }
}
