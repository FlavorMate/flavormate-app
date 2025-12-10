import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/models/features/category_drafts/category_group_dto.dart';
import 'package:flavormate/data/repositories/features/category_groups/p_rest_category_groups.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_categories/providers/p_recipe_editor_item_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemCategoriesPage extends ConsumerStatefulWidget {
  final String draftId;

  const RecipeEditorItemCategoriesPage({super.key, required this.draftId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemCategoriesPageState();

  PRecipeEditorItemCategoriesProvider get provider =>
      pRecipeEditorItemCategoriesProvider(draftId);

  PRestCategoryGroupsProvider get categoryGroupProvider =>
      pRestCategoryGroupsProvider(
        pageProviderId: PageableState.unused.name,
        pageSize: -1,
      );
}

class _RecipeEditorItemCategoriesPageState
    extends ConsumerState<RecipeEditorItemCategoriesPage> {
  bool _ready = false;

  final _debouncer = Debouncer();
  List<CategoryDto> _categories = [];

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (!_ready) {
        _categories = data;

        _ready = true;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.categoryGroupProvider,
      appBarBuilder: (_, _) => FAppBar(
        title: context.l10n.recipe_editor_item_categories_page__title,
        actions: [
          FProgress(
            provider: widget.provider,
            color: context.colorScheme.onSurface,
            optional: true,
            getProgress: (categories) => categories.isNotEmpty ? 1 : 0,
          ),
        ],
      ),
      builder: (_, data) => SafeArea(
        child: FResponsive(
          child: Card.outlined(
            child: Column(children: _buildTiles(data.data)),
          ),
        ),
      ),
      onError: FEmptyMessage(
        title: context.l10n.recipe_editor_item_categories_page__on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
    );
  }

  List<Widget> _buildTiles(List<CategoryGroupDto> groups) {
    final elements = groups
        .expand(
          (categoryGroup) => [
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(categoryGroup.label),
                  Text(
                    '(${countCategories(categoryGroup).trailingZeros()} / ${categoryGroup.categories.length.trailingZeros()})',
                  ),
                ],
              ),
              shape: const Border(),
              children: [
                for (final category in categoryGroup.categories)
                  CheckboxListTile(
                    value: _categories.any((c) => c.id == category.id),
                    onChanged: (_) => toggleCategory(category),
                    title: Text(category.label),
                  ),
              ],
            ),
            const Divider(height: 0),
          ],
        )
        .toList();
    elements.removeLast();

    return elements;
  }

  Future<void> toggleCategory(CategoryDto category) async {
    setState(() {
      _categories.addOrRemoveObject((c) => c.id == category.id, category);
    });

    _debouncer.run(() {
      ref.read(widget.provider.notifier).setCategories(_categories);
    });
  }

  int countCategories(CategoryGroupDto group) => group.categories
      .where((c) => _categories.where((c2) => c.id == c2.id).isNotEmpty)
      .length;
}
