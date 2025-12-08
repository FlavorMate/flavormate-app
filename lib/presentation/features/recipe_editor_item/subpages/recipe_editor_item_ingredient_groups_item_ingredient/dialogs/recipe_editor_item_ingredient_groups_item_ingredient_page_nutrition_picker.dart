import 'package:flavormate/core/config/features/p_feature_open_food_facts.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_full_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker
    extends ConsumerStatefulWidget {
  final RecipeDraftIngredientGroupItemNutritionDto nutrition;
  final UnitLocalizedDto? unit;
  final double? amount;

  const RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker({
    super.key,
    required this.nutrition,
    required this.unit,
    required this.amount,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DNutritionState();
}

class _DNutritionState
    extends
        ConsumerState<
          RecipeEditorItemIngredientGroupsItemIngredientPageNutritionPicker
        > {
  final double _dividerWidth = 250;

  final _formKey = GlobalKey<FormState>();

  int _mode = 1;

  late RecipeDraftIngredientGroupItemNutritionDto _nutrition;

  final _openFoodFactsIdController = TextEditingController();

  final _carbohydratesController = TextEditingController();
  final _energyKcalController = TextEditingController();
  final _fatController = TextEditingController();
  final _saturatedFatController = TextEditingController();
  final _sugarsController = TextEditingController();
  final _fiberController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _saltController = TextEditingController();
  final _sodiumController = TextEditingController();

  @override
  void initState() {
    _nutrition = widget.nutrition.copyWith();

    _openFoodFactsIdController.text = _nutrition.openFoodFactsId ?? '';

    _carbohydratesController.text = _nutrition.carbohydrates?.beautify ?? '';
    _energyKcalController.text = _nutrition.energyKcal?.beautify ?? '';
    _fatController.text = _nutrition.fat?.beautify ?? '';
    _saturatedFatController.text = _nutrition.saturatedFat?.beautify ?? '';
    _sugarsController.text = _nutrition.sugars?.beautify ?? '';
    _fiberController.text = _nutrition.fiber?.beautify ?? '';
    _proteinsController.text = _nutrition.proteins?.beautify ?? '';
    _saltController.text = _nutrition.salt?.beautify ?? '';
    _sodiumController.text = _nutrition.sodium?.beautify ?? '';

    if (_nutrition.openFoodFactsId?.isNotEmpty ?? false) {
      _mode = 0;
    }

    super.initState();
  }

  @override
  void dispose() {
    _openFoodFactsIdController.dispose();

    _carbohydratesController.dispose();
    _energyKcalController.dispose();
    _fatController.dispose();
    _saturatedFatController.dispose();
    _sugarsController.dispose();
    _fiberController.dispose();
    _proteinsController.dispose();
    _saltController.dispose();
    _sodiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offFeature = ref.watch(pFeatureOpenFoodFactsProvider);
    return FFullDialog(
      title: context
          .l10n
          .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__title,
      submit: submit,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: PADDING,
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_title,
                  ),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(
                    context
                        .l10n
                        .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__custom_title,
                  ),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selected) {
                setState(() {
                  _mode = selected.first;
                });
              },
            ),
            if (_mode == 0)
              if (!offFeature)
                FCard(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Row(
                    spacing: PADDING,
                    children: [
                      const Icon(MdiIcons.alertCircleOutline),
                      Expanded(
                        child: FText(
                          context
                              .l10n
                              .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_disabled,
                          style: FTextStyle.titleSmall,
                          color: FTextColor.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  spacing: PADDING,
                  children: [
                    FCard(
                      child: Column(
                        spacing: PADDING,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FText(
                            context
                                .l10n
                                .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_1,
                            style: FTextStyle.bodyMedium,
                            color: FTextColor.onPrimaryContainer,
                          ),
                          FText(
                            context
                                .l10n
                                .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_2,
                            style: FTextStyle.bodyMedium,
                            color: FTextColor.onPrimaryContainer,
                          ),
                          FText(
                            context
                                .l10n
                                .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_3,
                            style: FTextStyle.bodyMedium,
                            color: FTextColor.onPrimaryContainer,
                          ),
                          FText(
                            context
                                .l10n
                                .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_hint_4,
                            style: FTextStyle.bodyMedium,
                            color: FTextColor.onPrimaryContainer,
                          ),
                          FButton(
                            onPressed: launchOFF,
                            label: context
                                .l10n
                                .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_launch,
                          ),
                        ],
                      ),
                    ),
                    // if widget is null or not convertable
                    if (!convertableUnit)
                      FCard(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        child: Row(
                          spacing: PADDING,
                          children: [
                            const Icon(MdiIcons.alertCircleOutline),
                            Expanded(
                              child: FText(
                                context
                                    .l10n
                                    .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_unavailable,
                                style: FTextStyle.titleSmall,
                                color: FTextColor.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    FTextFormField(
                      controller: _openFoodFactsIdController,
                      label: context
                          .l10n
                          .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__off_ean,
                      prefix: const Icon(MdiIcons.barcodeScan),
                      readOnly: !convertableUnit,
                    ),
                  ],
                ),
            if (_mode == 1)
              Column(
                spacing: PADDING,
                children: [
                  if (!enableCustom)
                    FCard(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: Row(
                        spacing: PADDING,
                        children: [
                          const Icon(MdiIcons.alertCircleOutline),
                          Expanded(
                            child: FText(
                              context
                                  .l10n
                                  .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__custom_unavailable,
                              style: FTextStyle.titleSmall,
                              color: FTextColor.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  FCard(
                    child: FText(
                      context.l10n
                          .recipe_editor_item_ingredient_groups_item_ingredient_page_nutrition_picker__custom_hint_1(
                            [
                              widget.amount?.beautify,
                              widget.unit?.getLabel(widget.amount),
                            ].nonNulls.join(' '),
                          ),
                      style: FTextStyle.bodyMedium,
                      color: FTextColor.onPrimaryContainer,
                    ),
                  ),
                  FTextFormField(
                    controller: _energyKcalController,
                    label: context.l10n.nutrition__kcal,
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.fire),
                  ),
                  SizedBox(width: _dividerWidth, child: const Divider()),
                  FTextFormField(
                    controller: _carbohydratesController,
                    label: '${context.l10n.nutrition__carbohydrates} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.corn),
                  ),
                  FTextFormField(
                    controller: _sugarsController,
                    label: '${context.l10n.nutrition__sugars} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.cubeOutline),
                  ),
                  SizedBox(width: _dividerWidth, child: const Divider()),
                  FTextFormField(
                    controller: _fatController,
                    label: '${context.l10n.nutrition__fats} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.waterOutline),
                  ),
                  FTextFormField(
                    controller: _saturatedFatController,
                    label: '${context.l10n.nutrition__fats_saturated} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.foodDrumstickOutline),
                  ),
                  SizedBox(width: _dividerWidth, child: const Divider()),
                  FTextFormField(
                    controller: _fiberController,
                    label: '${context.l10n.nutrition__fibers} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.leaf),
                  ),
                  FTextFormField(
                    controller: _proteinsController,
                    label: '${context.l10n.nutrition__proteins} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.peanutOutline),
                  ),
                  FTextFormField(
                    controller: _saltController,
                    label: '${context.l10n.nutrition__salt} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.shakerOutline),
                  ),
                  FTextFormField(
                    controller: _sodiumController,
                    label: '${context.l10n.nutrition__sodium} (g)',
                    keyboardType: TextInputType.number,
                    readOnly: !enableCustom,
                    validators: validate,
                    prefix: const Icon(MdiIcons.flaskOutline),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool get convertableUnit {
    return (widget.unit?.unitRef.isConvertable ?? false) &&
        UDouble.isPositive(widget.amount);
  }

  String? validate(String? input) {
    if (EString.isEmpty(input)) return null;

    if (!UValidator.isNumber(input!)) {
      return context.l10n.validator__is_number;
    }

    return null;
  }

  bool get enableCustom {
    return _openFoodFactsIdController.text.isEmpty;
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    context.pop(
      RecipeDraftIngredientGroupItemNutritionDto(
        openFoodFactsId: _openFoodFactsIdController.text.trimToNull,
        carbohydrates: UDouble.tryParsePositive(_carbohydratesController.text),
        energyKcal: UDouble.tryParsePositive(_energyKcalController.text),
        fat: UDouble.tryParsePositive(_fatController.text),
        saturatedFat: UDouble.tryParsePositive(_saturatedFatController.text),
        sugars: UDouble.tryParsePositive(_sugarsController.text),
        fiber: UDouble.tryParsePositive(_fiberController.text),
        proteins: UDouble.tryParsePositive(_proteinsController.text),
        salt: UDouble.tryParsePositive(_saltController.text),
        sodium: UDouble.tryParsePositive(_sodiumController.text),
      ),
    );
  }

  void launchOFF() async {
    final language = Localizations.localeOf(context).languageCode;

    final url = switch (language) {
      'en' => OPEN_FOOD_FACTS_US,
      'de' => OPEN_FOOD_FACTS_DE,
      _ => throw UnimplementedError(),
    };

    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
