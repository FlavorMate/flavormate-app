import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/constants/shape_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/core/utils/u_debouncer.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/models/features/category_drafts/category_group_dto.dart';
import 'package:flavormate/data/repositories/features/category_groups/p_rest_category_groups.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_categories/providers/p_recipe_editor_item_categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

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

  final _scrollController = ScrollController();

  final _debouncer = UDebouncer();
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
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).listTheme.expandable;
    final style = M3EExpandableStyle.fromTheme(theme).copyWith(
      headerPadding: const .symmetric(
        vertical: PADDING / 2,
        horizontal: PADDING,
      ),
      headerAlignment: .center,
      useInkWell: false,
    );

    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
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
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FConstrainedBoxSliver(
              maxWidth: FBreakpoint.smValue,
              padding: const .all(PADDING),
              sliver: SliverMainAxisGroup(
                slivers: [
                  FPageIntroductionSliver(
                    shape: ShapeConstants.editor,
                    icon: Symbols.inventory_2_rounded,
                    description: context
                        .l10n
                        .recipe_editor_item_categories_page__description,
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  SliverToBoxAdapter(
                    child: FProviderStruct(
                      provider: widget.categoryGroupProvider,
                      onError: FEmptyMessage(
                        title: context
                            .l10n
                            .recipe_editor_item_categories_page__on_error,
                        icon: IconConstants.errorIcon,
                      ),
                      builder: (_, data) {
                        return M3EExpandableList(
                          style: style,
                          data: [
                            for (final categoryGroup in data.data)
                              M3EExpandableData(
                                title: categoryGroup.label,
                                trailing: Text(
                                  '(${countCategories(categoryGroup).trailingZeros()} / ${categoryGroup.categories.length.trailingZeros()})',
                                ),
                                body: Column(
                                  children: [
                                    for (final category
                                        in categoryGroup.categories)
                                      M3EListItem(
                                        headline: category.label,
                                        leading: Icon(
                                          _categories.any(
                                                (c) => c.id == category.id,
                                              )
                                              ? Symbols.check_circle_rounded
                                              : Symbols.circle_rounded,
                                          color: context.colorScheme.primary,
                                        ),
                                        onTap: () => toggleCategory(category),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
