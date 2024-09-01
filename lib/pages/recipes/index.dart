import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/recipes/p_recipes.dart';
import 'package:flavormate/riverpod/recipes/p_recipes_page.dart';
import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_recipes_title),
      body: SafeArea(
        child: TPageable(
          provider: pRecipesProvider,
          pageProvider: pRecipesPageProvider,
          builder: (_, recipes) => TWrap(
              children: recipes.content
                  .map((recipe) => TRecipeCard(recipe: recipe))
                  .toList()),
          onPressed: (ref, index) =>
              ref.read(pRecipesPageProvider.notifier).setState(index),
        ),
      ),
    );
  }
}
