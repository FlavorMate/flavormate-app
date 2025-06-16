import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_recipe_card.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/categories/p_category.dart';
import 'package:flavormate/riverpod/categories/p_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

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
          onEmpty: TEmptyMessage(
            icon: MdiIcons.archiveOffOutline,
            title: L10n.of(context).p_categories_no_recipe,
            subtitle: L10n.of(context).p_categories_no_recipe_subtitle,
          ),
          builder: (_, recipes) => TWrap(
            children: [
              for (final recipe in recipes.content) TRecipeCard(recipe: recipe),
            ],
          ),
        ),
      ),
    );
  }
}
