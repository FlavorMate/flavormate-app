import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/utils/debouncer.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups_item_ingredient/dialogs/recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups_item_ingredient/providers/p_recipe_editor_item_ingredient_groups_item_ingredient.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups_item_ingredient/widgets/recipe_editor_item_ingredient_groups_item_ingredient_page_unit_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemIngredientGroupsItemIngredientPage
    extends ConsumerStatefulWidget {
  const RecipeEditorItemIngredientGroupsItemIngredientPage({
    super.key,
    required this.draftId,
    required this.ingredientGroupId,
    required this.ingredientId,
  });

  final String draftId;
  final String ingredientGroupId;
  final String ingredientId;

  PRecipeEditorItemIngredientGroupsItemIngredientProvider get provider =>
      pRecipeEditorItemIngredientGroupsItemIngredientProvider(
        draftId,
        ingredientGroupId,
        ingredientId,
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorIngredientPageState();
}

class _RecipeEditorIngredientPageState
    extends ConsumerState<RecipeEditorItemIngredientGroupsItemIngredientPage> {
  bool _ready = false;

  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _amountDebouncer = Debouncer();
  final _labelController = TextEditingController();
  final _labelDebouncer = Debouncer();

  UnitLocalizedDto? _unit;
  RecipeDraftIngredientGroupItemNutritionDto? _nutrition;

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (!_ready) {
        _amountController.text = data.amount?.beautify ?? '';
        _labelController.text = data.label ?? '';
        _ready = true;
      }

      _nutrition = data.nutrition;
      _unit = data.unit;
    });

    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountDebouncer.dispose();
    _labelController.dispose();
    _labelDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(widget.provider);
    if (!_ready) {
      return const FLoadingPage();
    } else {
      return Scaffold(
        appBar: FAppBar(
          title: context
              .l10n
              .recipe_editor_item_ingredient_groups_item_ingredient_page__title,
          actions: [
            FProgress(
              provider: widget.provider,
              color: context.colorScheme.onSurface,
              getProgress: (instruction) => instruction.validPercent,
            ),
            IconButton(
              onPressed: deleteInstruction,
              icon: const Icon(MdiIcons.delete),
              color: context.blendedColors.error,
            ),
          ],
        ),
        body: SafeArea(
          child: FResponsive(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: PADDING,
                children: [
                  FTextFormField(
                    controller: _amountController,
                    label: context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page__amount,
                    onChanged: setAmount,
                    clear: () => setAmount(''),
                  ),
                  RecipeEditorItemIngredientGroupsItemIngredientPageUnitPicker(
                    initialValue: _unit?.labelSg,
                    onSelected: setUnit,
                    clear: () => setUnit(null),
                  ),

                  FTextFormField(
                    controller: _labelController,
                    label: context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page__label,
                    onChanged: setLabel,
                    clear: () => setLabel(''),
                  ),

                  FButton(
                    onPressed: openNutrition,
                    label: context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page__nutrition,
                    trailing: Visibility(
                      visible: _nutrition?.exists ?? false,
                      child: const Icon(MdiIcons.checkCircleOutline),
                    ),
                  ),

                  /// Needed to prevent UI behind FAB
                  const SizedBox(height: 56),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void setLabel(String label) {
    _labelDebouncer.run(() {
      ref.read(widget.provider.notifier).setLabel(label);
    });
  }

  void setAmount(String input) {
    _amountDebouncer.run(() {
      ref.read(widget.provider.notifier).setAmount(input);
    });
  }

  void setUnit(UnitLocalizedDto? unit) {
    ref.read(widget.provider.notifier).setUnit(unit?.id);
  }

  void openNutrition() async {
    final response =
        await showDialog<RecipeDraftIngredientGroupItemNutritionDto>(
          context: context,
          useSafeArea: false,
          builder: (_) =>
              RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker(
                amount: UDouble.tryParsePositive(_amountController.text),
                unit: _unit,
                nutrition:
                    _nutrition ??
                    RecipeDraftIngredientGroupItemNutritionDto.create(),
              ),
        );

    if (response == null) return;

    setState(() {
      _nutrition = response;
    });
    ref.read(widget.provider.notifier).setNutrition(response);
  }

  void deleteInstruction() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => FConfirmDialog(
        title: context
            .l10n
            .recipe_editor_item_ingredient_groups_item_ingredient_page__delete,
      ),
    );

    if (response != true || !mounted) return;
    context.showLoadingDialog();

    await ref.read(widget.provider.notifier).delete();

    if (!mounted) return;
    context.pop();
    context.pop();
  }
}
