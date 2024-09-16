import 'package:flavormate/components/riverpod/r_scaffold.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/tags/p_tags.dart';
import 'package:flavormate/riverpod/tags/p_tags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TagsPage extends ConsumerWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pTagsProvider);
    return RScaffold(
      provider,
      appBar: TAppBar(title: L10n.of(context).p_tags),
      builder: (_, tags) => tags.page.empty
          ? Center(
              child: TEmptyMessage(
                title: L10n.of(context).p_tags_no_recipe,
                subtitle: L10n.of(context).p_tags_no_recipe_subtitle,
                icon: MdiIcons.tagOffOutline,
              ),
            )
          : TPageable(
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
    );
  }
}
