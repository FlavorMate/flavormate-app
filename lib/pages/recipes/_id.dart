import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/recipes/p_recipes.dart';
import 'package:flavormate/riverpod/recipes/p_recipes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesPage extends ConsumerWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_recipes_title),
      body: SafeArea(
        child: TPageable(
          provider: pRecipesProvider,
          pageProvider: pRecipesPageProvider,
          onEmpty: TEmptyMessage(
            icon: MdiIcons.cookieOffOutline,
            title: L10n.of(context).p_recipes_no_recipe,
            subtitle: L10n.of(context).p_recipes_no_recipe_subtitle,
          ),
          builder:
              (_, recipes) => TWrap(
                children: [
                  for (final recipe in recipes.content)
                    TRecipeCard(recipe: recipe),
                ],
              ),
        ),
      ),
    );
  }
}
