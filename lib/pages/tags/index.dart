import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/tags/p_tags.dart';
import 'package:flavormate/riverpod/tags/p_tags_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_tags),
      body: SafeArea(
        child: TPageable(
          provider: pTagsProvider,
          pageProvider: pTagsPageProvider,
          builder: (_, tags) => TWrap(
            children: tags.content
                .map((tag) => SizedBox(
                      width: 450,
                      child: TCard(
                        padding: 0,
                        onTap: () => context.pushNamed(
                          'tag',
                          pathParameters: {'id': tag.id.toString()},
                          extra: tag.label,
                        ),
                        child: TImageLabel(
                          imageSrc: tag.recipes!.firstOrNull?.coverUrl,
                          type: TImageType.network,
                          height: 200,
                          title: tag.label,
                          labelSize: 0.4,
                        ),
                      ),
                    ))
                .toList(),
          ),
          onPressed: (ref, value) =>
              ref.read(pTagsPageProvider.notifier).setState(value),
        ),
      ),
    );
  }
}
