import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_content_card.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/categories/p_categories.dart';
import 'package:flavormate/riverpod/categories/p_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_categories),
      body: SafeArea(
        child: TPageable(
          provider: pCategoriesProvider,
          pageProvider: pCategoriesPageProvider,
          onEmpty: TEmptyMessage(
            icon: MdiIcons.archiveOffOutline,
            title: L10n.of(context).p_categories_no_recipe,
            subtitle: L10n.of(context).p_categories_no_recipe_subtitle,
          ),
          builder:
              (_, categories) => TWrap(
                children: [
                  for (final category in categories.content)
                    TContentCard(
                      onTap:
                          () => openCategory(
                            context,
                            category.id!,
                            category.label,
                          ),
                      content: TText(
                        category.label,
                        TextStyles.headlineSmall,
                        color: TextColor.white,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      contentHeight: 24,
                      emptyIcon: MdiIcons.tagOutline,
                      imageUrl: category.coverUrl,
                    ),
                ],
              ),
        ),
      ),
    );
  }

  void openCategory(BuildContext context, int id, String label) {
    context.pushNamed(
      'category',
      pathParameters: {'id': id.toString()},
      extra: label,
    );
  }
}
