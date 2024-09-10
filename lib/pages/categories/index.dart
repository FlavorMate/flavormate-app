import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/categories/p_categories.dart';
import 'package:flavormate/riverpod/categories/p_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_categories),
      body: SafeArea(
        child: TPageable(
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
      ),
    );
  }
}
