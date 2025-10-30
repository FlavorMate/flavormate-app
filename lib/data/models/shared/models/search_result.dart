import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SearchResult {
  final SearchResultType type;
  final String label;
  final String id;
  final IconData icon;

  SearchResult({required this.type, required this.label, required this.id})
    : icon = switch (type) {
        SearchResultType.author => MdiIcons.account,
        SearchResultType.book => MdiIcons.book,
        SearchResultType.category => MdiIcons.archive,
        SearchResultType.recipe => MdiIcons.foodForkDrink,
        SearchResultType.story => MdiIcons.star,
        SearchResultType.tag => MdiIcons.tag,
      };
}

enum SearchResultType { author, book, category, recipe, story, tag }
