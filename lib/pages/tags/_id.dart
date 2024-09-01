import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/tags/p_tag.dart';
import 'package:flavormate/riverpod/tags/p_tag_page.dart';
import 'package:flutter/material.dart';

class TagPage extends StatelessWidget {
  final int id;
  final String? title;

  const TagPage({required this.id, super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: title ?? L10n.of(context).p_tag),
      body: SafeArea(
        child: TPageable(
          provider: pTagProvider(id),
          pageProvider: pTagPageProvider,
          builder: (_, recipes) => TWrap(
            children: recipes.content
                .map((recipe) => TRecipeCard(recipe: recipe))
                .toList(),
          ),
          onPressed: (ref, value) =>
              ref.read(pTagPageProvider.notifier).setState(value),
        ),
      ),
    );
  }
}
