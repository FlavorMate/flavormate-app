import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_content_card.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_text.dart';
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
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_tags),
      body: SafeArea(
        child: TPageable(
          provider: pTagsProvider,
          pageProvider: pTagsPageProvider,
          onEmpty: TEmptyMessage(
            title: L10n.of(context).p_tags_no_recipe,
            subtitle: L10n.of(context).p_tags_no_recipe_subtitle,
            icon: MdiIcons.tagOffOutline,
          ),
          builder: (_, tags) => TWrap(
            children: [
              for (final tag in tags.content)
                TContentCard(
                  onTap: () => openTag(context, tag.id!, tag.label),
                  content: TText(
                    tag.label,
                    TextStyles.headlineSmall,
                    color: TextColor.white,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  contentHeight: 24,
                  emptyIcon: MdiIcons.tagOutline,
                  imageUrl: tag.coverUrl,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void openTag(BuildContext context, int id, String label) {
    context.pushNamed(
      'tag',
      pathParameters: {'id': id.toString()},
      extra: label,
    );
  }
}
