import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_pageable.dart';
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
    final provider = ref.watch(pCategoriesProvider);
    return RScaffold(
      provider,
      appBar: TAppBar(title: L10n.of(context).p_categories),
      builder: (_, categories) => categories.page.empty
          ? Center(
              child: TEmptyMessage(
                icon: MdiIcons.archiveOffOutline,
                title: L10n.of(context).p_categories_no_recipe,
                subtitle: L10n.of(context).p_categories_no_recipe_subtitle,
              ),
            )
          : TPageable(
              provider: pCategoriesProvider,
              pageProvider: pCategoriesPageProvider,
              builder: (_, categories) => TWrap(
                  children: categories.content
                      .map(
                        (category) => SizedBox(
                          width: 450,
                          child: TCard(
                            padding: 0,
                            onTap: () => context.pushNamed(
                              'category',
                              pathParameters: {'id': category.id.toString()},
                              extra: category.label,
                            ),
                            child: TImageLabel(
                              imageSrc: category.recipes!.firstOrNull?.coverUrl,
                              type: TImageType.network,
                              height: 200,
                              title: category.label,
                              labelSize: 0.4,
                            ),
                          ),
                        ),
                      )
                      .toList()),
              onPressed: (ref, value) =>
                  ref.read(pCategoriesPageProvider.notifier).setState(value),
            ),
    );
  }
}
