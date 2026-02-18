import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

part 'search_dto.mapper.dart';

@MappableClass()
class SearchDto with SearchDtoMappable {
  final String id;
  final SearchDtoSource source;
  final String label;
  final String? cover;

  const SearchDto(this.id, this.source, this.label, this.cover);

  String? url(ImageResolution resolution) =>
      cover?.let((it) => '$it?resolution=${resolution.name}');
}

@MappableEnum()
enum SearchDtoSource {
  Account,
  Book,
  Category,
  Recipe,
  Story,
  Tag
  ;

  String getName(BuildContext context) {
    return switch (this) {
      .Account => context.l10n.search__account,
      .Book => context.l10n.search__book,
      .Category => context.l10n.search__category,
      .Recipe => context.l10n.search__recipe,
      .Story => context.l10n.search__story,
      .Tag => context.l10n.search__tag,
    };
  }

  Shapes get shape => switch (this) {
    .Account => Shapes.c6_sided_cookie,
    .Book => Shapes.very_sunny,
    .Category => Shapes.l4_leaf_clover,
    .Recipe => Shapes.square,
    .Story => Shapes.pentagon,
    .Tag => Shapes.pill,
  };

  IconData get icon => switch (this) {
    .Account => MdiIcons.account,
    .Book => MdiIcons.book,
    .Category => MdiIcons.archive,
    .Recipe => MdiIcons.foodVariant,
    .Story => MdiIcons.chat,
    .Tag => MdiIcons.tag,
  };
}
