import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/categories/p_category.dart';
import 'package:flavormate/riverpod/categories/p_category_page.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final int id;
  final String? title;

  const CategoryPage({required this.id, super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: title ?? L10n.of(context).p_category),
      body: SafeArea(
        child: TPageable(
          provider: pCategoryProvider(id),
          pageProvider: pCategoryPageProvider,
          builder: (_, recipes) => TWrap(
            children: recipes.content
                .map((recipe) => TRecipeCard(recipe: recipe))
                .toList(),
          ),
          onPressed: (ref, value) =>
              ref.read(pCategoryPageProvider.notifier).setState(value),
        ),
      ),
    );
  }
}
