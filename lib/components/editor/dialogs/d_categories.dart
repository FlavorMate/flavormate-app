import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_full_dialog.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/draft/p_draft_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DCategories extends ConsumerStatefulWidget {
  final List<int> categories;

  const DCategories({
    super.key,
    required this.categories,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DCategoriesState();
}

class _DCategoriesState extends ConsumerState<DCategories> {
  late List<int> _categories;

  @override
  void initState() {
    _categories = List.of(widget.categories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pDraftCategoriesProvider);
    return TFullDialog(
        title: L10n.of(context).d_editor_categories_title,
        submit: submit,
        child: RStruct(
          provider,
          (_, categoryGroups) => Column(
            children: [
              for (final categoryGroup in categoryGroups.entries)
                ExpansionTile(
                  title: Text(categoryGroup.key),
                  children: [
                    for (final category in categoryGroup.value)
                      CheckboxListTile(
                        value: _categories.contains(category.id),
                        onChanged: (_) => toggleCategory(category.id!),
                        title: Text(category.label),
                      )
                  ],
                ),
            ],
          ),
        ));
  }

  void submit() {
    context.pop(_categories);
  }

  toggleCategory(int id) {
    final index = _categories.indexOf(id);
    setState(() {
      if (index < 0) {
        _categories.add(id);
      } else {
        _categories.removeAt(index);
      }
    });
  }
}
