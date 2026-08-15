import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
  Tag;

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

  M3EShapeKind get shape => switch (this) {
    .Account => .cookie6Sided,
    .Book => .verySunny,
    .Category => .clover4Leaf,
    .Recipe => .square,
    .Story => .pentagon,
    .Tag => .pill,
  };

  IconData get icon => switch (this) {
    .Account => Symbols.group_rounded,
    .Book => Symbols.book,
    .Category => Symbols.inventory_2_rounded,
    .Recipe => Symbols.grocery_rounded,
    .Story => Symbols.chat_rounded,
    .Tag => Symbols.sell_rounded,
  };
}
